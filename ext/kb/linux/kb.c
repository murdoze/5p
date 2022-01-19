/* Build me with:
   gcc -shared -o kb.so -undefined dynamic_lookup kb.c -lncurses
*/

/* Copyright (C) 2012 Ross Andrews
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/lgpl.txt>. */

#include <ncurses.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#include <stdio.h>
#include <sys/ioctl.h>

int getch_wrapper(lua_State *L);
int get_console_size(lua_State *L);

int luaopen_kb(lua_State *L){
    luaL_Reg fns[] = {
        {"getch", getch_wrapper},
        {"get_console_size", get_console_size},
        {NULL, NULL}
    };

    luaL_openlib(L, "kb", fns, 0);

    initscr(); /* Start curses */
    raw(); /* Turn off line buffering */
    set_escdelay(25); /* Shorten delay after ESC key to something reasonable */
    keypad(stdscr, TRUE); /* Grab ALL kbd input */
    refresh(); /* Store screen state so endwin works */
    endwin(); /* Leave curses mode */

    return 0;
}

int get_console_size(lua_State *L)
{
    struct winsize max;
    ioctl(0, TIOCGWINSZ , &max);

    lua_pushnumber(L, max.ws_col);
    lua_pushnumber(L, max.ws_row);

    return 2;
}

int getch_wrapper(lua_State *L)
{
    reset_prog_mode(); /* Get back into curses */
    lua_pushnumber(L, getch()); /* Grab a char and push it */
    endwin(); /* Get out of curses again */
    return 1;
}
