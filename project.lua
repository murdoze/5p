local pp, inkey, push, read = unpack(require 'lib/all')

local hl = require'highlight'
local nonnull = require'nonnull'
local serpent = require'serpent'

local display = require'display'

local genid = require'genid'
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
 
  data.people = nonnull.value(new_data.people, data.people)
  data.tasks = nonnull.value(new_data.tasks, data.tasks)
  data.customers = nonnull.value(new_data.customers, data.customers)
  data.milestones = nonnull.value(new_data.milestones, data.milestones)
  data.drones = nonnull.value(new_data.drones, data.drones)

  status_text = "Loaded project data from " .. project.dir
end

local function save_data()
  local res, err = serdes.save_dir(project.dir, data)
  if not res then
    status_text = hl.White() .. hl.BgRed() .. err
  end
end

-- Chord processing

local input = {}

input.in_search = false
input.search_str = ''

input.number = 0
input.last_number = 0

local current_chord = ''
local last_chord = ''

local chords = {}

local function make_chord(chord, func, text, continue_chord)
  local ch = { func =  func, name = chord, text = text, continue = continue_chord }

  table.insert(chords, ch)
  chords[chord] = ch
end

local function chars_for(key)
  if input.in_search then
    if key ~= 10 then
      if key == 27 then
        input.in_search = false
      else
        input.search_str = input.search_str .. string.char(key)
      end  
      return ''
    end  
  end

  if key >= string.byte('0') and key <= string.byte('9') then
    input.number = input.number * 10 + (key - string.byte('0'))
    return ''
  end

  local keymap =
  {
    [10] = '<ENTER>',
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
  if chars == '' then return nil end


  current_chord = current_chord .. chars

  local chord = chords[current_chord]

  if chord ~= nil then
    -- play the chord

    last_chord = current_chord

    if chord.continue then
    else
      current_chord = ''
    end
    input.last_number = input.number

    return chord
  else
    -- start over
    last_chord = current_chord
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
  display.print(" 5p: Personal Portable Project Planning Pentagram or Personal Jira ")
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
  display.print("(" .. tostring(#items) .. ")")

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
  if view.update ~= nil then
    view:update()
  end

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

-- Table filter

local function filter(t, func)
  local r = {}

  for i, it in ipairs(t) do
    if func(it) then
      table.insert(r, it)
    end
  end

  return r
end

-- Views

local chords_view =
{
  title = " Chords ",
  items = chords,
  update = function(self) self.items = filter(chords, function(it) return true end) end 
}

local chords_list_view = 
{
  title = " List: ",
  update = function(self) self.items = filter(chords, function(it) return string.sub(it.name, 1, 1) == 'l' end) end 
}

local people_view = 
{
  title = ' People ',
  items = {},
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.people end
}

local tasks_view = 
{
  title = ' Tasks ',
  items = data.tasks,
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.tasks end
}

local customers_view =
{  
  title = ' Customers ',
  items = nil,
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.customers end
}

local milestones_view =
{  
  title = ' Milestones ',
  items = nil,
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.milestones end
}

local drones_view =
{  
  title = ' Drones ',
  items = nil,
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.drones end
}


-- Edit in Vim

local function edit_all_in_vim()
  save_data()
  os.execute(serdes.get_vim_cmdline(project.dir)) 
  load_data()
end

local function edit_in_vim(s)
  local tempfile = os.tmpname()  

  local f = io.open(tempfile, 'w+')
  if f ~= nil then
    f:write(s)
    f:close()
  end

  os.execute('vim ' .. tempfile)

  local f = io.open(tempfile, "r")

  if f ~= nil then
    s = f:read("*l")
    f:close()
  end

  os.remove(tempfile)

  return s
end

-- Item manipulation
local yanked_item = {}

local function copy_item(it)
  local r = {}

  r.id = nil
  r.name = it.name
  r.text = it.text
  r.labels = it.labels
  r.assigned_to = it.assigned_to

  return r
end

local function get_current_item()
  local cursor = display.view.cursor
  if cursor == nil then return nil end
  
  local it = display.view.items[cursor]

  return it
end

local function edit_current_item(field)
  local it = get_current_item()
  if it ~= nil then
    it[field] = edit_in_vim(nonnull.value(it[field], '')) 
  end
end

local function delete_current_item()
  local cursor = display.view.cursor
  if cursor == nil then return nil end

  local it = table.remove(display.view.items, cursor)

  yanked_item = copy_item(it)

  if #display.view.items < cursor then
    display.view.cursor = #display.view.items
  end
end

local function insert_item(offset)
  local cursor = display.view.cursor
  if cursor == nil then return nil end

  local it = {}
  it.id = genid()
  it.name = ''
  it.text = ''

  table.insert(display.view.items, cursor + offset, it)
end

local function paste_item()
  local cursor = display.view.cursor
  if cursor == nil then return nil end

  local it = {}
  it.id = genid()
  it.name = yanked_item.name
  it.text = yanked_item.text
  it.labels = yanked_item.labels
  it.assigned_to = yanked_item.assigned_to

  table.insert(display.view.items, cursor, it)
end

-- Selecting items

local function select(args)
  local items = nonnull.value(args.items, {})
  local multiple = nonull.value(args.multiple, false)
  local selected = nonnull.value({})

  local prev_view = display.view

  local view =
  {
    items = items,
    start = 1,
    cursor = 1,
  }

end

local function choose_items()
end

local function select_person()
end

local function select_customer()
end

local function select_drone()
end

-- Enter key multimodal handler (could do better)

local function handle_enter()
  if input.in_search then
    input.in_search = false
    print(input.search_str)
    inkey()
  else
  end
end

-- Saving and Quitting 

local function quit()
  print(hl.Reset()())
  print(hl.RestoreScreen()())
  os.exit(0)
end

local function save_and_quit()
  save_data()
  quit()
end

local function quit_no_save()
  quit()
end

-- Chords

make_chord('?', function() set_current_screen(function() show_view(chords_view) end) end, "Show chords help")
make_chord('<^H>', function() set_current_screen(function() show_items("Chords", chords) end) end, "Show chords help")
make_chord('--------------------------------------------')
make_chord('q', nil, "Quit", true)
make_chord('qq', save_and_quit, "Save and quit")
make_chord('q!', quit_no_save, "Quit without saving")
make_chord('<^S>', save_data, "Save data")
make_chord('<^O>', load_data, "Load data")
make_chord('--------------------------------------------')
make_chord('l', function() set_current_screen(function() show_view(chords_list_view) end) end, "List", true)
make_chord('lp', function() set_current_screen(function() show_view(people_view) end) end, "List people")
make_chord('lt', function() set_current_screen(function() show_view(tasks_view) end) end, "List tasks")
make_chord('lc', function() set_current_screen(function() show_view(customers_view) end) end, "List customers")
make_chord('lm', function() set_current_screen(function() show_view(milestones_view) end) end, "List milestones")
make_chord('ld', function() set_current_screen(function() show_view(drones_view) end) end, "List drones")
make_chord('<DOWN>', function() scroll{ by = 1 } end, 'Scroll up')
make_chord('<UP>', function() scroll{ by = -1 } end, 'Scroll down')
make_chord('<PGDOWN>', function() scroll{ by = display.list_count } end, 'Scroll page up')
make_chord('<PGUP>', function() scroll{ by = -display.list_count } end, 'Scroll page down')
make_chord('<HOME>', function() scroll{ to = 1 } end, 'First item')
make_chord('<END>', function() scroll{ to = #display.view.items } end, 'Last item')
make_chord('--------------------------------------------')
make_chord('i', function() insert_item(0) end, 'Insert item above')
make_chord('A', function() insert_item(1) end, 'Insert item below')
make_chord('d', function() delete_current_item() end, 'Delete current item')
make_chord('p', function() paste_item() end, 'Paste item')
make_chord('--------------------------------------------')
make_chord('e', function() end, 'Edit', true)
make_chord('ea', function() edit_all_in_vim() end, 'Edit all in Vim')
make_chord('en', function() edit_current_item'name' end, 'Edit name in Vim')
make_chord('et', function() edit_current_item'text' end, 'Edit text in Vim')
make_chord('--------------------------------------------')
make_chord('/', function() input.in_search = true; input.search_str = '' end, 'Search')
make_chord('<CR>', function() handle_enter() end, 'Do search! / Accept selection')
make_chord('g', function() if input.last_number ~= 0 then current_chord = ''; scroll{ to = input.last_number }; input.number = 0; input.last_number = 0; end end, 'Go to...', true)
make_chord('--------------------------------------------')
make_chord('s', function() end, 'Select', true)
make_chord(' ', function() choose_items() end, 'Choose item(s)')
make_chord('sp', function() select_person() end, 'Select person')
make_chord('sc', function() select_customer() end, 'Select customer')
make_chord('sd', function() select_drone() end, 'Select drone')

-- ------------------------------------------------------------------------------------------------------------------------

do
  local key = 0
  local chord = nil

  load_data()

  print(hl.SaveScreen()())

  while true do

    display.show_border = show_border
    display.show_header = show_header
    display.show_status = show_status

    display.draw()
 
    key = inkey()

    chord = chord_for(key)

    if chord ~= nil then
      local func = chord.func
      if func ~= nil then
        func()
      end
    end  

    status_text = "Chord .. [" .. last_chord .. "] Key [" .. tostring(key) .. "]"
    if input.number ~= 0 then status_text = status_text .. " Number [" .. tostring(input.number) .. "]" end
    if input.in_search then status_text = status_text .. " Search [" .. input.search_str .. "]" end

  end
end


