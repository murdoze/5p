-- Displaying functions

local hl = require'highlight'

local display = {}

display.width = 80
display.height = 30

display.header_line = 2
display.title_line = display.header_line + 2
display.status_line = -1

display.list_begin_line = display.title_line + 3
display.list_end_line = -1

display.get_window_size = function()
  local tmp_lines=os.tmpname()
  local tmp_cols=os.tmpname()
  os.execute("tput lines > " .. tmp_lines)
  os.execute("tput cols > " .. tmp_cols)
  local h = tonumber(io.lines(tmp_lines)())
  local w = tonumber(io.lines(tmp_cols)())
  os.remove(tmp_lines)
  os.remove(tmp_cols)

  display.height = h
  display.width = w
end

display.handle_resize = function()
  display.status_line = display.height - 1
  display.list_end_line = display.status_line - 2
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
  display.current_screen()
  display.show_status()
  display.show_keys()
  io.flush()
end

return display
