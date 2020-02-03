local curses = require "curses"

require "socket"

function sleep(sec)
    socket.select(nil, nil, sec)
end

local function main ()
    local stdscr = curses.initscr ()

    curses.cbreak ()
    curses.echo (false)
    curses.curs_set(0)

    x = 0
    y = 0
    next_x = 0
    direction = 1

    while(true)
        do
            max_y, max_x = stdscr:getmaxyx()
            stdscr:clear ()
            stdscr:mvaddstr(y, x, "o")
            stdscr:refresh()

            sleep(0.05)

            next_x = x + direction

            if next_x >= max_x or next_x < 0 then
                direction = direction * -1
            else
                x = x + direction
            end
        end
end

local function err (err)
    curses.endwin ()
    print "Caught an error:"
    print (debug.traceback (err, 2))
    os.exit (2)
end

xpcall (main, err)
