hl = require'highlight'

local console = require'kb'
local inkey = console.getch

local colors = {}
colors.items = {}

local function make_color(id, color, text)
  local color =
  {
    id = id,
    name = color,
    text = text,
    color = { items = { { id = id, name = color } } },
  }
  table.insert(colors.items, color)
end

colors.items =
{
  [1] = {
    id = 'wb',
    name = hl.White() .. hl.BgBlack(),
    text = 'White on Black',
    color =
    {
      items = { { id = 'wrb', name = hl.White() .. hl.BgBlack() } }
    }
   },
  [2] = {
    id = 'wr',
    name = hl.White() .. hl.BgRed(),
    text = 'White on Red',
    color =
    {
      items = { { id = 'wr', name = hl.White() .. hl.BgRed() } }
    }
  },

  [3] = {
    id = 'w_37',
    name = hl.White() .. hl.BgColor8(0x37)(),
    text = 'White on Violet37'
  },

}

make_color('Bw_37', hl.Bold() .. hl.White() .. hl.BgColor8(0x37)(), "Bold White on Violet37")
make_color('By_37', hl.Bold() .. hl.Yellow() .. hl.BgColor8(0x10)(), "Gold on Black")


return colors
