(import
    chicken.format
    chicken.port
    chicken.process.signal
    srfi-12
    srfi-18
    (prefix ncurses ncurses:))

(define log-port (open-output-file "out.log"))
(set-buffering-mode! log-port #:line)

(define y 0)
(define x 0)
(define max_y 0)
(define max_x 0)
(define next_x 0)
(define direction 1)

(define (draw)
    (let loop ()
        (define scrnum (ncurses:stdscr))
        (set!-values (max_y max_x) (ncurses:getmaxyx scrnum))

        (ncurses:clear)
        (ncurses:mvprintw y x "@")
        (ncurses:refresh)

        (thread-sleep! 0.1)

        (case (ncurses:getch)
            ((#\k) (set! y (- y 1)))
            ((#\j) (set! y (+ y 1)))
            ((#\l) (set! x (+ x 1)))
            ((#\h) (set! x (- x 1)))
            (else (display "DOH\n" log-port)))

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
