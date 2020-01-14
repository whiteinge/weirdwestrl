(import
    chicken.format
    chicken.port
    chicken.process.signal
    chicken.random
    srfi-12
    srfi-18
    (prefix ncurses ncurses:))

(define log-port (open-output-file "out.log"))
(set-buffering-mode! log-port #:line)
(define (out s . args)
    (apply format log-port (string-append s "\n") args))

(define (draw-floor y x max_y max_x)
    (when (and (< y max_y) (< x max_x))
        (out "~a ~a" y x)
        (ncurses:mvprintw y x ".")
        (draw-floor (+ y 1) (+ x 1) max_y max_x)))

(define (draw-floor y x max_y max_x)
    (out "~a ~a ~a ~a" y x max_y max_x)
    (cond
        ((= y max_y) '())
        ((= x max_x) (draw-floor (+ y 1) 0 max_y max_x))
        ((< x max_x) (begin
            (ncurses:mvprintw y x ".")
            (draw-floor y (+ x 1) max_y max_x)))))

(define (draw)
    (define y 0)
    (define x 0)
    (define max_y 0)
    (define max_x 0)

    (define scrnum (ncurses:stdscr))
    (set!-values (max_y max_x) (ncurses:getmaxyx scrnum))

    (ncurses:clear)
    ; Why do I get an out of bounds error when writing to the last column?
    ; Maybe it writes then moves the (hidden) cursor to the next column which
    ; is then out of bounds? Do I still get out of bounds errors when writing
    ; to non-root windows?
    (draw-floor 0 0 max_y (- max_x 1))
    (ncurses:refresh)

    (out "Done with the drawing")

    (let loop ()
        ; (ncurses:clear)
        ; (ncurses:mvprintw y x "@")
        ; (ncurses:refresh)

        (case (ncurses:getch)
            ((#\k) (set! y (- y 1)))
            ((#\j) (set! y (+ y 1)))
            ((#\l) (set! x (+ x 1)))
            ((#\h) (set! x (- x 1)))
            (else (out "DOH")))

        (loop)))

(define (main)
    (set-signal-handler! signal/int (lambda (sig)
        (begin
            (ncurses:curs_set 1)
            (ncurses:endwin)
            (display "Bye!\n")
            (exit 0))))

    (handle-exceptions exn
        (begin
            (ncurses:curs_set 1)
            (ncurses:endwin)
            (display "Caught error: ")
            (display ((condition-property-accessor 'exn 'message "message unknown") exn))
            (newline)
            (print-call-chain))
        (ncurses:initscr)
        (ncurses:noecho)
        (ncurses:curs_set 0)
        (draw)
        (ncurses:curs_set 1)
        (ncurses:endwin)))

(main)
