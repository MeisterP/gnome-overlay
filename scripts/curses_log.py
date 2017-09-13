import curses

class CursesLog:
    def __init__(self, screen=None):
        self._rows = {}
        self._screen = screen if screen else curses.initscr()
        curses.noecho()
        curses.nocbreak()
        self._screen.scrollok(True)
        self._screen.idlok(True)
        self._screen.immedok(True)

    def add_str(self, marker, message, append=False, *args, **kwargs):
        if marker in self._rows:
            d = self._rows[marker]
            if not append:
                self._screen.addstr(d["y"], d["x"] , message, *args, **kwargs)
            else:
                self._screen.addstr(d["y"], d["end"], message, *args, **kwargs)
        else:
            self._screen.addstr(len(self._rows) + 1, 0, message, *args, **kwargs)

        y, x = self._screen.getyx()
        self._rows[marker] = {
            "y": y,
            "x": x - len(message),
            "end": x
        }
        self._screen.refresh()

    def exit():
        curses.endwin()
