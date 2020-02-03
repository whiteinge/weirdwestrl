local ncurses = require "ncurses"

local ffi = require "ffi"

ffi.cdef[[
    void Sleep(int ms);
    int poll(struct pollfd *fds,unsigned long nfds,int timeout);
]]
sleep = function(millisec)
    ffi.C.poll(nil,0,millisec)
end

local function main ()
    local stdscr = ncurses.initscr ()

    ncurses.noecho ()
    ncurses.curs_set(0)

    x = 0
    y = 0
    next_x = 0
    direction = 1

    while(true)
        do
            max_x = ncurses.getmaxx(ncurses.stdscr)
            ncurses.clear ()
            ncurses.mvaddstr(y, x, "o")
            ncurses.refresh()

            sleep(30)

            next_x = x + direction

            if next_x >= max_x or next_x < 0 then
                direction = direction * -1
            else
                x = x + direction
            end
        end
end

local function err (err)
    ncurses.endwin ()
    print "Caught an error:"
    print (debug.traceback (err, 2))
    os.exit (2)
end

xpcall (main, err)
