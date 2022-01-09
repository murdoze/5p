-- Displaying functions

local hl = require'highlight'

local display = {}

display.width = 80
display.height = 30

display.header_line = 3
display.title_line = display.header_line + 2
display.status_line = -1

display.list_begin_line = display.title_line + 3
display.list_end_line = -1

display.on_resize = function(height, width)
  display.status_line = height
  display.list_end_line = display.status_line - 2
end

--
display.locate = function(line, column)
  if column == nil then column = 1 end
  io.write(hl.Locate(line, column)())
end

display.print = function(s)
  io.write(s)
end

display.print_line = function(s)
  io.write(hl.pad(hl.cut(s, display.width), display.width) .. "|" .. hl.Off())
end

display.show_header = function() end
display.show_status = function() end
display.show_keys = function() end

display.current_screen = function() end

display.draw = function()
  display.on_resize(display.height, display.width)
  io.flush()
  print(hl.Cls())

  display.show_header()
  display.current_screen()
  display.show_status()
  display.show_keys()
  io.flush()
end

return display
