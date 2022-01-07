-- Loads common functions and modules, returns them as a list
-- Beware of order!

package.cpath='./ext/?/?.so;'..package.cpath
package.path='./lib/?.lua;'..package.path

local all = {}
local function register(...)
  local funcs={...}
  for i, v in ipairs(funcs) do
    table.insert(all, v)
  end
end

--


local serpent = require'serpent'
local pp = function(_) print(serpent.block(_, {nocode = true, sortkeys = true, comment = false})) end

local kb = require'kb'
local getch = function() return kb.getch() end

local push = function(t, v) table.insert(t, v) end

register(
  pp, getch, push
)

return all



