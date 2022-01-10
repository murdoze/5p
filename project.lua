local pp, inkey, push = unpack(require 'lib/all')

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
  chords[chord] = { func =  func, text = text, continue = continue_chord }
end

local function charsFor(key)
  local keymap =
  {
  }

  local cmd = keymap[key]
  if cmd == nil then
    if key >= 0 and key <= 255 then
      cmd = string.char(key)
    else
      cmd = ''
    end
  end

  return cmd
end

local function chordFor(key)
  local chars = charsFor(key)
  current_chord = current_chord .. chars

  -- print("==>" .. current_chord .. "<==")

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
  display.locate(display.header_line)
  display.print_line(hl.White() .. hl.BgRed() .. "5p: Personal Portable Project Planning Paradise")
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


local function show_help()
  show_title('HELP !!!!!!!')

  local b = hl.Border(10, 10, 5, 20)

  print(b)
end

local function show_list()
  show_title"LIST!!!!"
  -- show_line_numbers()
end

local function show_items(items)
  items = nonnull.list(items)

  local lines = display.list_end_line - display.list_begin_line + 1

  for i, it in ipairs(items) do
    display.locate(display.list_begin_line + i - 1)
    display.print_line(hl.Yellow() .. string.format("%3d", i) .. hl.Off() .. ". " .. hl.align(nonnull.value(it.name, '?'), 20) .. " " .. hl.Faint() .. nonnull.value(it.text, ''))

    lines = lines - 1
    if lines <= 0 then break end
  end
end

local function show_people_list(people)
  show_title"People"
  show_items(nonnull.value(people, data.people))
end

local function show_task_list(tasks)
  show_title("Tasks")
  show_items(nonnull.value(tasks, data.tasks))
end


local function hlRedUnderlined(s) return hl.Red() .. hl.Underline() .. s .. hl.Off() end

make_chord('?', function() set_current_screen(show_help) end, "Show chords help")

make_chord('l', function() set_current_screen(show_list) end, "List: " .. hlRedUnderlined('p') .. "eople, tasks,..", true)
make_chord('lp', function() set_current_screen(show_people_list) end, "List people")
make_chord('lt', function() set_current_screen(show_task_list) end, "List tasks")

make_chord(CTRL_'Q', function() display.print(hl.RestoreScreen()()); os.exit(0) end, 'Quit')

make_chord(CTRL_'S', save_data, 'Save data')
make_chord(CTRL_'O', load_data, 'Load data')

-- ------------------------------------------------------------------------------------------------------------------------

do
  local key = 0
  local chars = ''
  local chord = nil

  display.print(hl.SaveScreen()())

  while chars ~= 'q' do

    display.show_border = show_border
    display.show_header = show_header
    display.show_status = show_status

    display.draw()
 
    key = inkey()
    -- print(hl.Cls())
 
    chars = charsFor(key)
    chord = chordFor(key)

   

    -- print(hl.Locate(10, 40)() .. key .. " => [" .. current_chord .. "] ")

    if chord ~= nil then
      local func = chord.func
      if func ~= nil then
        func()
        pp(chord)
      end
    end  

  end

  display.print(hl.RestoreScreen()())
end


