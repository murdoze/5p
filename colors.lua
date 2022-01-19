local colors = {}

hl = require'highlight'

local console = require'kb'
local inkey = console.getch

colors.items =
{
  [1] = {
    id = 'wb',
    name = hl.White() .. hl.BgBlack(),
    text = 'White on Black'
  },
  [2] = {
    id = 'wr',
    name = hl.White() .. hl.BgRed(),
    text = 'White on Red'
  },

}

--[[
local i = 1
for id, it in pairs(colors.items) do
  it.id = id
  colors.items[i] = it
  i = i + 1
end
]]

return colors
