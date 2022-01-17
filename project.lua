-- Imports

package.cpath='./ext/?/?.so;'..package.cpath
package.path='./lib/?.lua;'..package.path

local hl = require'highlight'
local nonnull = require'nonnull'

local serpent = require'serpent'
local pp = function(_) print(serpent.block(_, { nocode = true, sortkeys = true, comment = false })) end

local kb = require'kb'
local inkey = function() return kb.getch() end

local display = require'display'

local genid = require'genid'
local data = require'data'
local serdes = require'serdes'

require'noglobals'

-- String utilities

string.pad = function(s, width, char)
  local pad = width - string.len(s)
  if pad > 0 then
    if char == nil then char = ' ' end
    return s .. string.rep(char, pad)
  else
    return s
  end
end

string.cut = function(s, width)
  if string.len(s) > width then
    return string.sub(s, 1, width)
  else
    return s
  end
end

-- Deep copy

-- http://lua-users.org/wiki/CopyTable -- modified, no metatables
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function copy(t)
  return deepcopy(t)
end

-- Status

local status_text = 'Status normal'

-- Project

local project = {}

project.dir = "./examples/project2/"

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
  data.labels = nonnull.value(new_data.labels, data.labels)

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
    [27] = '<ESC>',
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

local function show_related(items)
  if items == nil then return "" end

  local s = "["

  for i, it in ipairs(items) do
    if i > 1 then s = s .. "|" end
    s = s .. it.name
  end

  s = s .. "]"

  return s
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

      local selected = " "
      if display.view.selected ~= nil then
        for _, sit in ipairs(display.view.selected.items) do
	  if it.id == sit.id then
	      selected = "+"
	    break
	  end
	end
      end

      local related = ""

      if it.related ~= nil then
        related = show_related(it.related.people.items) 
          .. show_related(it.related.labels.items) 
          .. show_related(it.related.drones.items) 
          .. show_related(it.related.customers.items) 
          .. show_related(it.related.milestones.items) 
      end

      display.print_line(" " .. cursor .. selected .. " " .. hl.Yellow() .. string.format("%6d", i) .. hl.Off() .. ". " .. hl.align(nonnull.value(it.name, '?'), 20) .. " " 
        .. hl.Bold() .. related .. hl.Off()
        .. hl.Faint() .. nonnull.value(it.text, ''))

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
  items = nil,
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.people end
}

local tasks_view = 
{
  title = ' Tasks ',
  items = nil,
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


local labels_view =
{  
  title = ' Labels ',
  items = nil,
  start = 1,
  cursor = 1,
  update = function(self) self.items = data.labels end
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
  r.related = copy(it.related) 

  return r
end

local function get_current_item()
  local cursor = display.view.cursor
  if cursor == nil then return nil end
  
  local item = display.view.items[cursor]

  return item
end

local function get_current_item_and_related()
  local item = get_current_item()
  if item == nil then return nil end

  if item.related == nil then
    item.related = copy(display.view.items.related)
  end

  return item
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
  if it == nil then return end

  yanked_item = copy_item(it)

  if #display.view.items < cursor then
    display.view.cursor = #display.view.items
  end
end

local function insert_item(offset)
  local cursor = display.view.cursor
  if cursor == nil then return nil end
  if cursor == 0 then offset = 1 end

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
  it.related = copy(yanked_item.related)

  table.insert(display.view.items, cursor, it)
end

-- Selecting items

local function select(args)
  -- local title = nonnull.value(args.title, ' Select: ')
  local title = args.title or ' Select: '
  local items = args.items
  local multiselect = nonnull.value(args.multiselect, false)
  local selected = args.selected

  display.prev_view = display.view

  local view =
  {
    title = title,
    items = items,
    start = 1,
    cursor = 1,
    selecting = true,
    multiselect = multiselect,
    selected = selected,
  }
  set_current_screen(function() show_view(view) end)
end

local function choose_items()
  local view = display.view
  if nonnull.value(view.selecting, false) then
    local item = view.items[view.cursor]
    if view.multiselect then
      local exists = false
      for i, it in ipairs(view.selected.items) do
        if it.id == item.id then
	  exists = true
	  table.remove(view.selected.items, i) 
	  break
	end
      end
      if not exists then
        table.insert(view.selected.items, { name = item.name, id = item.id })
      end
    else
      view.selected.items = { { name = item.name, id = item.id } }
    end
  end
end

local function select_person()
  local item = get_current_item_and_related()
  if item == nil then return end

  local selected = item.related.people
  select{ title = ' Select person ', items = data.people, multiselect = true, selected = selected }
end

local function select_customer()
  local item = get_current_item()
  if item == nil then return end

  local t = display.view.items.type

  if t == data.Type.Task then
    select{ title = nil, items = data.customers, multiselect = true, selected = item.customers }
  end

  if t == data.Type.Task then
  end

  if t == data.Type.Task then
  end


end

local function select_drone()
  local item = get_current_item()
  if item == nil then return end

  select{ title = ' Select drones ', items = data.drones, multiselect = true, selected = {} }
end

local function return_to_prev_view()
  if display.prev_view ~= nil then
    if nonnull.value(display.view.selecting, false) then
      set_current_screen(function() show_view(display.prev_view) end)
    end
  end
end

-- Enter key multimodal handler (could do better)

local function handle_enter()
  if input.in_search then
    -- Search
    input.in_search = false
    print(input.search_str)
    inkey()
  else
    -- Choosing item(s)
    return_to_prev_view()
 end
end


local function handle_escape()
  return_to_prev_view()  
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
make_chord('ll', function() set_current_screen(function() show_view(labels_view) end) end, "List labels")
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
make_chord('<ENTER>', function() handle_enter() end, 'Do search! / Accept selection')
make_chord('<ESC>', function() handle_escape() end, 'Accept selection via escape')
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
        -- local co = coroutine.create(func)
	-- coroutine.resume(co)
      end
    end  

    status_text = "Chord .. [" .. last_chord .. "] Key [" .. tostring(key) .. "]"
    if input.number ~= 0 then status_text = status_text .. " Number [" .. tostring(input.number) .. "]" end
    if input.in_search then status_text = status_text .. " Search [" .. input.search_str .. "]" end

  end
end


