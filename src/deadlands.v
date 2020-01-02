#flag -lncurses
#include "ncurses.h"

fn C.clear() voidptr
fn C.curs_set(c bool) voidptr
fn C.endwin() voidptr
fn C.initscr() voidptr
fn C.mvprintw(y int, x int, c string) voidptr
fn C.noecho() voidptr
fn C.refresh() voidptr
fn C.getmaxyx(stdscr, y int, x int) voidptr

const (
	delay = 30000
)

fn main() {
	C.initscr()
	C.noecho()
	C.curs_set(false)

	mut x := 0
	y := 0
	mut max_y := 0
	mut max_x := 0
	mut next_x := 0
	mut direction := 1

	for {
		C.getmaxyx(C.stdscr, max_y, max_x)

		C.clear()

		C.mvprintw(y, x, "o")
		C.refresh()

		usleep(delay)

		next_x = x + direction

		if next_x >= max_x || next_x < 0 {
			direction *= -1
		} else {
			x += direction
		}
	}

	C.endwin()
}
