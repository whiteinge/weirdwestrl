(import
    chicken.format
    chicken.process.signal
    ncurses
    srfi-12
    srfi-18)

(define y 0)
(define x 0)
(define max_y 0)
(define max_x 0)
(define next_x 0)
(define direction 1)

(define (draw)
    (let loop ()
        (define scrnum (stdscr))
        (set!-values (max_y max_x) (getmaxyx scrnum))
        (clear)
        (mvprintw y x "o")
        (refresh)

        (set! next_x (+ x direction))

        (cond
            ((>= next_x max_x) (set! direction (* direction -1)))
            ((< next_x 0) (set! direction (* direction -1)))
            (else (set! x (+ x direction))))

        (thread-sleep! 0.1)
        (loop)))

(define (main)
    (set-signal-handler! signal/int (lambda (sig)
        (begin
            (curs_set 1)
            (endwin)
            (display "Bye!\n")
            (exit 0))))

    (handle-exceptions exn
        (begin
            (curs_set 1)
            (endwin)
            (display (format "XXX ~a, ~a, ~a, ~a" direction x next_x max_x))
            (newline)
            (display "Caught error: ")
            (display ((condition-property-accessor 'exn 'message "message unknown") exn))
            (newline)
            (print-call-chain))
            ; (abort exn))
        (initscr)
        (noecho)
        (curs_set 0)
        (draw)
        (curs_set 1)
        (endwin)))

(main)
