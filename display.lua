-- Displaying functions

local hl = require'highlight'

local display = {}

display.width = 80
display.height = 30

display.header_line = 1
display.title_line = 3
display.status_line = -1

display.list_begin_line = 5
display.list_end_line = -1

display.on_resize = function(height, width)
  display.status_line = height
  display.list_end_line = display.status_line - 2
end

display.print_line = function(s)
  print(string.pad(s, display.width))
end

display.show_header = function() end
display.show_status = function() end

display.current_screen = function() end

display.draw = function()
  display.on_resize(display.height, display.width)
  print(hl.Cls())

  display.show_header()
  display.current_screen()
  display.show_status()
end

return display
