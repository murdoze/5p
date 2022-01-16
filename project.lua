local pp, inkey, push, read = unpack(require 'lib/all')

local hl = require'highlight'
local nonnull = require'nonnull'
local serpent = require'serpent'

local display = require'display'

local data = require'data'
local serdes = require'serdes'

require'noglobals'

-- Status

local status_text = 'Status normal'

-- Project

local project = {}

project.dir = "./examples/project1/"

local function load_data()
  local res, new_data = serdes.load_dir(project.dir)
  if not res then
    status_text = hl.White() .. hl.BgRed() .. new_data
    return
  end

  data.people = new_data.people
  data.tasks = new_data.tasks
  data.customers = new_data.customers
  data.milestones = new_data.milestones
  data.drones = new_data.drones
end

local function save_data()
  local res, err = serdes.save_dir(project.dir, data)
  if not res then
    status_text = hl.White() .. hl.BgRed() .. err
  end
end

-- Chord processing

local function CTRL_(c)
  local b = string.byte(c) - string.byte'A' + 1

  return string.char(b)
end

local current_chord = ''

local chords = {}

local function make_chord(chord, func, text, continue_chord)
  local ch = { func =  func, name = chord, text = text, continue = continue_chord }

  table.insert(chords, ch)
  chords[chord] = ch
end

local function chars_for(key)
  local keymap =
  {
    [262] = '<HOME>',
    [360] = '<END>',
    [259] = '<UP>',
    [258] = '<DOWN>',
    [339] = '<PGUP>',
    [338] = '<PGDOWN>',
  }

  local cmd = keymap[key]
  if cmd == nil then
    if key >= 0 and key < 32 then
      cmd = '<^' .. string.char(string.byte('@') + key) .. '>'
    elseif key >= 32 and key <= 255 then
      cmd = string.char(key)
    else
      cmd = ''
    end
  end

  return cmd
end

local function chord_for(key)
  local chars = chars_for(key)
  current_chord = current_chord .. chars

  local chord = chords[current_chord]

  if chord ~= nil then
    -- play the chord

    if chord.continue then
    else
      current_chord = ''
    end

    return chord
  else
    -- start over
    current_chord = ''

    return nil
  end
end

-- Displays

local function set_current_screen(func)
  display.current_screen = func
end

local function show_border()
  display.print(hl.Border(1, 1, display.height, display.width))
end

local function show_ruler()
  local r10 = "" 
  local r01 = ""
  for i = 0, 179 do
    if i % 10 == 0 then r10 = r10 .. string.char(i / 10 + string.byte('0')) else r10 = r10 .. " " end
    r01 = r01 .. string.char(i % 10 + string.byte('0'))
  end


  display.locate(1)
  -- display.print_line(hl.BgBlue() .. r10)
  display.locate(2)
  -- display.print_line(hl.BgYellow() .. r01)
end

local function show_title(s)
  local col = math.floor(display.width / 2 - string.len(s) / 2)

  display.locate(display.title_line, col)
  display.print(hl.BgCyan() .. hl.White() .. s .. " " .. hl.Off())
end

local function show_header()
  show_ruler()
  display.locate(display.header_line - 1)
  display.print(" 5p: Personal Portable Project Planning Paradise ")
end

local function show_line_numbers()
  for i = display.list_begin_line,display.list_end_line do
    display.locate(i)
    display.print_line(string.format("%2d", i) .. ". " .. hl.BgYellow())
  end
end

local function show_status()
  display.locate(display.status_line)
  display.print_line(hl.White() .. hl.BgBlue() .. status_text)
end

local function show_items(title, items)
  show_title(title)

  display.view.items = items
  items = nonnull.list(items)
  display.view.start = nonnull.value(display.view.start, 1)

  local lines = display.list_count

  if display.view.start < 1 then display.view.start = 1 end
  if display.view.start > #items then display.view.start = #items end


  local cursor_line = -1
  for i, it in ipairs(items) do
    if i >= display.view.start then
      local current_line = display.list_begin_line + i - 1 - display.view.start
      display.locate(current_line)
      local cursor = " "
      if i == display.view.cursor then
        cursor = hl.Green() .. hl.Bold() .. ">" .. hl.Off()
	cursor_line = current_line
      end
      display.print_line(" " .. cursor .. " " .. hl.Yellow() .. string.format("%6d", i) .. hl.Off() .. ". " .. hl.align(nonnull.value(it.name, '?'), 20) .. " " .. hl.Faint() .. nonnull.value(it.text, ''))

      lines = lines - 1
      if lines <= 0 then break end
    end
  end

  if cursor_line ~= -1 then
    display.locate(cursor_line, 3)
  end
end

local function show_view(view)
  display.view = view

  show_items(view.title, view.items)
end

--

local function scroll(args)
  local by = args.by
  local to = args.to
  local view = display.view

  if view.cursor ~= nil then

    if to ~= nil then
      view.cursor = to 
    else
      view.cursor = view.cursor + by
    end

    if view.cursor < 1 then view.cursor = 1 end

    while view.cursor < view.start do
      view.start = view.start - display.list_count
    end
    if view.start < 1 then view.start = 1 end

    if view.cursor > #view.items then view.cursor = #view.items end

    while view.start + display.list_count <= view.cursor do
      view.start = view.start + display.list_count
    end

  else
  
    if to ~= nil then
      view.start = to
    else
      view.start = view.start + by
    end

    if view.start < 1 then view.start = 1 end
    if view.start > #view.items then view.start = #view.items end

  end
end

local function scroll_up()
  scroll_by(1)
end

-- Views

local chords_view =
{
  title = " Chords ",
  items = chords
}

local people_view = 
{
  title = ' People ',
  items = data.people,
  start = 1,
  cursor = 1,
}

local tasks_view = 
{
  title = ' Tasks ',
  items = data.tasks,
  start = 1,
  cursor = 1,
}


-- Edit in Vim

local function edit_all_in_vim()
  save_data()
  os.execute(serdes.get_vim_cmdline(project.dir)) 
  load_data()
end

-- 

local function quit()
  print(hl.RestoreScreen()())
  print(hl.RestoreScreen()())
  print(hl.RestoreScreen()())
  os.exit(0)
end

-- Chords

make_chord('?', function() set_current_screen(function() show_view(chords_view) end) end, "Show chords help")
make_chord('<^H>', function() set_current_screen(function() show_items("Chords", chords) end) end, "Show chords help")

make_chord('l', function() end, "List", true)

make_chord('lp', function() set_current_screen(function() show_view(people_view) end) end, "List people")
make_chord('lt', function() set_current_screen(function() show_view(tasks_view) end) end, "List tasks")
make_chord('lc', function() set_current_screen(function() show_items("Customers", data.customers) end) end, "List customers")
make_chord('lm', function() set_current_screen(function() show_items("Milestones", data.milestones) end) end, "List milestones")
make_chord('ld', function() set_current_screen(function() show_items("Drones", data.drones) end) end, "List drones")

make_chord('<^Q>', quit, 'Quit')
make_chord('q', quit, 'Quit')

make_chord('<^S>', save_data, 'Save data')
make_chord('<^O>', load_data, 'Load data')

make_chord('<DOWN>', function() scroll{ by = 1 } end, 'Scroll up')
make_chord('<UP>', function() scroll{ by = -1 } end, 'Scroll down')
make_chord('<PGDOWN>', function() scroll{ by = display.list_count } end, 'Scroll page up')
make_chord('<PGUP>', function() scroll{ by = -display.list_count } end, 'Scroll page down')
make_chord('<HOME>', function() scroll{ to = 1 } end, 'First item')
make_chord('<END>', function() scroll{ to = #display.view.items } end, 'Last item')

make_chord('i', function() local s = read() end, 'Read')

make_chord('e', function() end, 'Edit', true)
make_chord('ea', function() edit_all_in_vim() end, 'Edit all in Vim')

-- ------------------------------------------------------------------------------------------------------------------------

do
  local key = 0
  local chord = nil

  print(hl.SaveScreen()())
  print(hl.SaveScreen()())
  print(hl.Reset()())

  while true do

    display.show_border = show_border
    display.show_header = show_header
    display.show_status = show_status

    display.draw()
 
    key = inkey()
 
    chord = chord_for(key)


    if chord ~= nil then
      status_text = "Chord: .. [" ..current_chord .. "] key: [" .. key .. "]"
      local func = chord.func
      if func ~= nil then
        func()
      end
    end  

  end

  --display.print(hl.RestoreScreen()())
end


