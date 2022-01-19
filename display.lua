-- Displaying functions

local hl = require'highlight'

local kb = require'kb' -- TODO: rename kb to console

local display = {}
local view = {}

view.start = 1
view.items = {}

display.view = view

display.width = 80
display.height = 30

display.header_line = 2
display.title_line = display.header_line + 2
display.list_count = 0
display.status_line = -1
display.keystatus_line = -1

display.list_begin_line = display.title_line + 3

display.get_window_size = function()
  local w, h = kb.get_console_size()

  display.height = h
  display.width = w

end

display.handle_resize = function()
  display.status_line = display.height - 2
  display.keystatus_line = display.height - 1
  display.list_count = display.status_line - display.list_begin_line - 1
end

--

display.locate = function(line, column)
  if column == nil then column = 2 end
  io.write(hl.Locate(line, column)())
end

display.print = function(s)
  io.write(s)
end

display.print_line = function(s)
  io.write(hl.align(s, display.width - 2) .. hl.Off())
end

local noop = function() end

display.show_header = noop
display.show_status = noop
display.show_keys = noop
display.show_border = noop

display.current_screen = function() end

display.draw = function()
  io.flush()

  display.get_window_size()
  display.handle_resize()
  display.print(hl.Cls())

  display.show_border()
  display.show_header()
  display.show_status()
  display.show_keys()

  display.current_screen()
  io.flush()
end

return display
