val clear = _import "clear" : unit -> unit;
val curs_set = _import "curs_set" : bool -> unit;
val endwin = _import "endwin" : unit -> unit;
val initscr = _import "initscr" : unit -> int;
val mvprintw = _import "mvprintw" : int * int * string -> unit;
val noecho = _import "noecho" : unit -> unit;
val refresh = _import "refresh" : unit -> unit;
val getmaxy = _import "getmaxy" : int -> int;
val getmaxx = _import "getmaxx" : int -> int;

val stdscr = initscr ();

val _ = noecho ();
val _ = curs_set (false);

val x = 0;
val y = 0;
val next_x = 0;
val direction = 1;

fun loop (x, next_x, direction) =
  let
    val max_x = getmaxx (stdscr);
    val _ = clear();
    val _ = mvprintw (y, x, "o");
    val _ = refresh();
    val _ = Posix.Process.sleep(Time.fromMicroseconds(30000));
    val next_x = x + direction;
  in
    if next_x >= max_x orelse next_x < 0 then
      loop(x, next_x, direction * ~1)
    else
      loop(x + direction, next_x, direction)
  end;

val _ = loop(x, next_x, direction);
