-- Loads common functions and modules, returns them as a list
-- Beware of order!

-- Paths and registration

package.cpath='./ext/?/?.so;'..package.cpath
package.path='./lib/?.lua;'..package.path

local all = {}
local function register(...)
  local funcs={...}
  for i, v in ipairs(funcs) do
    table.insert(all, v)
  end
end

-- String utilities

string.pad = function(s, width, char)
  local pad = width - string.len(s)
  if pad > 0 then
    if char == nil then char = ' ' end
    return s .. string.rep(char, pad)
  else
    return s
  end
end

string.cut = function(s, width)
  if string.len(s) > width then
    return string.sub(s, 1, width)
  else
    return s
  end
end

-- Exporting common functions

local serpent = require'serpent'
local pp = function(_) print(serpent.block(_, {nocode = true, sortkeys = true, comment = false})) end

local kb = require'kb'
local getch = function() return kb.getch() end

local push = function(t, v) table.insert(t, v) end

register(
  pp, getch, push
)

return all



