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

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#include <conio.h>

#include <windows.h>

int getch_wrapper(lua_State *L);
int get_console_size(lus_State *L);

int luaopen_kb(lua_State *L){
    luaL_Reg fns[] = {
        {"getch", getch_wrapper},
        {"get_console_size", getch_wrapper},
        {NULL, NULL}
    };

    luaL_openlib(L, "kb", fns, 0);

    return 0;
}

int get_console_size(lus_State *L) 
{
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    int columns, rows;

    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
    columns = csbi.srWindow.Right - csbi.srWindow.Left + 1;
    rows = csbi.srWindow.Bottom - csbi.srWindow.Top + 1;

    lua_pushnumber(L, columns);
    lua_pushnumber(L, rows);
    return 0;
}

int getch_wrapper(lua_State *L){
    lua_pushnumber(L, getch()); /* Grab a char and push it */
    return 1;
}
