-- OS-dependent logic
is_windows = false

if jit and jit.os then
  if jit.os == 'Windows' then is_windows = true end
end

-- Paths

if is_windows then
  package.cpath = '.\\ext\\?\\' .. package.cpath
else
  package.cpath = './ext/?/?.so;' .. package.cpath
end

package.path='./lib/?.lua;'..package.path

-- Imports

local hl = require'highlight'

local serpent = require'serpent'
local pp = function(_) print(serpent.block(_, { nocode = true, sortkeys = true, comment = false })) end

local console = require'kb'
local inkey = console.getch

local display = require'display'


local genid = require'genid'

local db = require'db'
local data = db.data
local index = db.index

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

local keystatus_text = 'Key status normal'
local hlKeyStatus = hl.Off() .. hl.White() .. hl.BgBlue()

-- Project

local path_separator

if is_windows then
  path_separator = "\\"
else
  path_separator  = "/"
end

local project = {}

project.dir = "." .. path_separator

local function add_to_index(items)
  for _, it in ipairs(items) do
    local id = it.id
    index[id] = it
  end
end

local function load_data()
  local dirf, err = io.open(project.dir)
  if not dirf then
    status_text = hl.White() .. hl.BgRed() .. err
    return
  else
    io.close(dirf)
  end

  local res, new_data = serdes.load_dir(project.dir)
  if not res then
    status_text = hl.White() .. hl.BgRed() .. new_data
    return
  end
 
  data.people = new_data.people or data.people
  data.tasks = new_data.tasks or data.tasks
  data.customers = new_data.customers or data.customers
  data.milestones = new_data.milestones or data.milestones
  data.drones = new_data.drones or data.drones
  data.labels = new_data.labels or data.labels
  data.colors = new_data.colors or data.colors

  index = {} -- Loaded new data , clean the index
  add_to_index(data.people)
  add_to_index(data.tasks)
  add_to_index(data.customers)
  add_to_index(data.milestones)
  add_to_index(data.drones)
  add_to_index(data.labels)
  add_to_index(data.colors)

  status_text = "Loaded project data from " .. project.dir
end

local function save_data()
  local res, err = serdes.save_dir(project.dir, data)
  if not res then
    status_text = hl.White() .. hl.BgRed() .. err
  else  
    status_text = hl.White() .. hl.BgGreen() .. "Data saved to " .. project.dir
  end

  return res
end

-- Chord processing

local input = {}

input.in_search = false
input.search_str = ''

input.number = -1
input.last_number = -1

local current_chord = ''
local last_chord = ''

local chords = {}

local function make_chord(args)
  local chords = args.chords or chords
  local ch = { func =  args.func, name = args.chord or '', text = args.text, continue = args.continue }

  table.insert(chords, ch)
  if args.chord then chords[args.chord] = ch end
end


-- BEWARE!!! This function has side effects
-- TODO:     Get rid of sid effects
local function chars_for(key)
  if input.in_search then
    if key ~= 10 then
      if key == 27 then
        input.in_search = false
      else
        if key >= 32 and key <= 255 then
          input.search_str = input.search_str .. string.char(key)
	end
	if key == 263 then -- DEL. TODO: Support on Windows
	  if #input.search_str > 0 then
	    input.search_str = string.sub(input.search_str, 1, #input.search_str - 1)
	  end
	end
      end  
      return ''
    end  
  end

  if key >= string.byte('0') and key <= string.byte('9') then
    if input.number == -1 then input.number = 0 end
    input.number = input.number * 10 + (key - string.byte('0'))
    return ''
  end

  local keymap

  if is_windows then 
    keymap = 
    {
      [10] = '<ENTER>',
      [27] = '<ESC>',
      [71] = '<HOME>',
      [79] = '<END>',
      [72] = '<UP>',
      [80] = '<DOWN>',
      [73] = '<PGUP>',
      [81] = '<PGDOWN>',
    }
  else
    keymap = 
    {
      [10] = '<ENTER>',
      [27] = '<ESC>',
      [262] = '<HOME>',
      [360] = '<END>',
      [259] = '<UP>',
      [258] = '<DOWN>',
      [339] = '<PGUP>',
      [338] = '<PGDOWN>',
      [263] = '<DEL>',
    }
   end

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

-- BEWARE!!! This function has side effects
--           It can be called only once per a key pressed
local function chord_for(chars, chords, chords2)
  if chars == '' then return nil end

  current_chord = current_chord .. chars

  local chord = chords[current_chord]
  if chord == nil and chords2 then
    chord = chords2[current_chord]
  end

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
  display.print(" 5p: Personal Portable Project Planning Pseudovim")
end

local function show_line_numbers()
  for i = display.list_begin_line,display.list_end_line do
    display.locate(i)
    display.print_line(string.format("%2d", i) .. ". " .. hl.BgYellow())
  end
end

local function show_status()
  display.locate(display.status_line)
  display.print_line(status_text)
end

local function show_keystatus()
  display.locate(display.keystatus_line)
  display.print_line(hlKeyStatus .. keystatus_text)
end

local function get_related_str(items)
  if items == nil then return "" end

  local items = items.items
  if items == nil or #items == 0 then return "" end

  local s = "|"

  for i, item in ipairs(items) do
    if i > 1 then s = s .. "|" end

    s = s .. item.name
  end

  s = s .. "|"

  return s
end

local function show_related(items)
  if items == nil then return "" end

  local items = items.items
  if items == nil or #items == 0 then return "" end

  local s = "["

  for i, item in ipairs(items) do
    if i > 1 then s = s .. "|" end

    local has_color = false
    local it = index[item.id]
    if it ~= nil then
      local color = ""
      if it.color and it.color.items and it.color.items[1] then
        color = it.color.items[1].name
	s = s .. color
	has_color = true
      end
    end

    s = s .. item.name

    if has_color then
      s = s .. hl.Off()
    end
  end

  s = s .. "]"

  return s
end

local function show_item(it, i, cursor_line, line_index)
  local current_line = display.list_begin_line + line_index - 1 - display.view.start
  display.locate(current_line)

  local text = it.text or ''

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
    related = show_related(it.related.people) 
      .. show_related(it.related.labels) 
      .. show_related(it.related.drones) 
      .. show_related(it.related.customers) 
      .. show_related(it.related.milestones)

    if related ~= "" then related = related .. " " end  
  end

  local color = ""
  if it.color and it.color.items and it.color.items[1] then
    color = it.color.items[1].name
  end

  local s = " "

  s = s .. cursor .. selected .. " " .. hl.Yellow() .. string.format("%6d", i) .. hl.Off() .. ". " 
  if display.view.hide_name then
  else
    if display.view.color_name then
      s = s .. hl.align(color .. (it.name or '?') .. hl.Off(), 20)
    else
      s = s .. hl.align(it.name or '?', 20)
    end
    s = s .. hl.Off() .. " " 
  end	
  s = s .. related .. hl.Off()
  if display.view.color_text then
    s = s .. color
  else
    if i == display.view.cursor then
      s = s .. hl.BgCyan() .. hl.BrightWhite() .. hl.Bold()
    else
      s = s .. hl.Faint()
    end
  end
  s = s .. text .. hl.Off()

  display.print_line(s)

end

local function show_items(title, items)
  show_title(title)

  if input.search_str ~= '' and #input.search_str > 1 then
    local filtered_items = {}

    for i, it in ipairs(items) do
      local related_str = ''

      if it.related ~= nil then
        related_str = get_related_str(it.related.people) 
          .. get_related_str(it.related.labels) 
          .. get_related_str(it.related.drones) 
          .. get_related_str(it.related.customers) 
          .. get_related_str(it.related.milestones)
      end	
      local text = string.lower(related_str) .. string.lower(it.text or '')
      local pattern = string.lower(input.search_str)

      local skip = true

      for _ in string.gmatch(text, pattern) do
        skip = false
        break
      end

      if not skip then
        table.insert(filtered_items, it)
      end
    end

    items = filtered_items
  end

  display.print("(" .. tostring(#items) .. ")")

  display.view.items = items
  items = items or {}
  display.view.start = display.view.start or 1

  local lines = display.list_count

  if display.view.start < 1 then display.view.start = 1 end
  if display.view.start > #items then display.view.start = #items end


  local cursor_line = -1
  local line_index = 1
  for i, it in ipairs(items) do
    if i >= display.view.start then
      show_item(it, i, cursor_line, line_index)

      line_index = line_index + 1
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

-- Edit in Vim

local function edit_all_in_vim()
  save_data()
  os.execute(serdes.get_vim_cmdline(project.dir)) 
  load_data()
end

local function edit_in_vim(s)
  local tempfile = os.tmpname()

  if is_windows then
    tempfile = os.getenv'TEMP' .. '\\' .. tempfile
  end

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
  r.color = copy(it.color) 

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
    it[field] = edit_in_vim(it[field] or '')
  end
end

local function yank_current_item()
  local it = get_current_item()
  if it == nil then return end

  yanked_item = copy_item(it)
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
 
  cursor = cursor + offset
  display.view.cursor = cursor

  local id = genid()
  local it = {}

  it.id = id
  it.name = ''
  it.text = ''

  table.insert(display.view.items, cursor, it)
  index[id] = it
end

local function paste_item(offset)
  if not offset then offset = 0 end
  local cursor = display.view.cursor
  if cursor == nil then return nil end

  cursor = cursor + offset

  local id = genid()
  local it = {}
  it.id = id
  it.name = yanked_item.name
  it.text = yanked_item.text
  it.related = copy(yanked_item.related)
  it.color = copy(yanked_item.color)

  table.insert(display.view.items, cursor, it)
  
  index[id] = it

  display.view.cursor = cursor
end

local function move_item(offset)
  local cursor = display.view.cursor
  if cursor == nil then return nil end

  local old_cursor = cursor

  cursor = cursor + offset

  if offset == 1 then
    -- Special case: when a number is entered, moving to specified location, not down by 1
    if input.number >= 1 then
      cursor = input.number
      if cursor > #display.view.items then cursor = #display.view.items end
    end
  end
  
  if cursor < 1 or cursor > #display.view.items then return end

  local it = table.remove(display.view.items, old_cursor)
  if it == nil then return end
   
  table.insert(display.view.items, cursor, it)

  display.view.cursor = cursor
end

-- Selecting items

local function select(args)
  local title = args.title or ' Select: '
  local items = args.items
  local multiselect = args.multiselect or false
  local selected = args.selected

  if selected == nil then return end

  local hide_name = args.hide_name
  local color_name = args.color_name
  local color_text = args.color_text

  display.prev_view = display.view

  local view =
  {
    title = title,
    items = items,
    start = 1,
    cursor = 1,
    selecting = true,
    multiselect = multiselect,
    hide_name = hide_name,
    color_name = color_name or true,
    color_text = color_text,
    selected = selected,
  }
  set_current_screen(function() show_view(view) end)
end

local function choose_items()
  local view = display.view
  if view.selecting then
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
  local item = get_current_item_and_related()
  if item == nil then return end

  local selected = item.related.customers

  local t = display.view.items.type

  if t == data.Type.Task then
    select{ title = nil, items = data.customers, multiselect = true, selected = selected }
  end

  if t == data.Type.Task then
  end

  if t == data.Type.Task then
  end


end

local function select_drone()
  local item = get_current_item_and_related()
  if item == nil then return end

  local selected = item.related.drones

  select{ title = ' Select drones ', items = data.drones, multiselect = true, selected = selected }
end

local function select_label()
  local item = get_current_item_and_related()
  if item == nil then return end

  local selected = item.related.labels

  select{ title = ' Select labels ', items = data.labels, multiselect = true, selected = selected }
end

local function return_to_prev_view()
  if display.prev_view ~= nil then
    if display.view.selecting then
      set_current_screen(function() show_view(display.prev_view) end)
    end
  end
end

-- Coloring

local function color_item()
  local item = get_current_item()
  if item == nil then return end

  if not item.color then
    item.color = { items = { id = '' } }
  end

  select{ title = ' Select color ', items = data.colors, multiselect = false, selected = item.color, hide_name = false, color_text = true }
end

-- Enter key multimodal handler (could do better)

local function handle_enter()
  if input.in_search then
    -- Search
    input.in_search = false
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
  print(hl.RestoreScreen()())
  display.locate(display.height)
  os.exit(0)
end

local function save_and_quit()
  if save_data() then
    quit()
  end
end

local function quit_no_save()
  quit()
end

-- Views

--- Colors

local function make_color_hl(args)
  local s = ''

  if args.bold then s = s .. hl.Bold() end

  if args.fg_color then
    if args.fg_bright then
      s = s .. hl.BrightColor(args.fg_color)()
    else
      s = s .. hl.Color(args.fg_color)()
    end
  end

  if args.bg_color then
    if args.bg_bright then
      s = s .. hl.BrightBgColor(args.bg_color)()
    else
      s = s .. hl.BgColor(args.bg_color)()
    end
  end

  return s
end

local function make_color_text(args)
  local s = ''

  local color_names =
  {
    'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White'
  }

  if args.bold then s = s .. "Bold " end

  if args.fg_color then
    if args.fg_bright then
      s = s .. 'Bright '
    end
    s = s .. color_names[args.fg_color + 1]
  end

  if args.bg_color then
    if s ~= '' then s = s .. ' on ' end

    if args.bg_bright then
      s = s .. 'Bright '
    end
    s = s .. color_names[args.bg_color + 1]
    s = s .. ' Background'
  end

  return s
end

local function change_current_color(args)
  local color = get_current_item()
  if color == nil then return end

  args.bg_bright = args.bg_bright or false
  args.fg_bright = args.fg_bright or false

  if args.toggle_bold then color.bold = not color.bold end

  if args.bg_color then
    if args.bg_color >= 0 and args.bg_color <= 7 then 
      color.bg_color = args.bg_color
    end
    if args.bg_color == -1 then
      if not color.bg_color then color.bg_color = 0 end
      color.bg_color = (color.bg_color + 1) % 8
    end
  end

  if args.fg_color then
    if args.fg_color >= 0 and args.fg_color <= 7 then 
      color.fg_color = args.fg_color
    end
    if args.fg_color == -1 then
      if not color.fg_color then color.fg_color = 0 end
      color.fg_color = (color.fg_color + 1) % 8
    end
  end

  color.bg_bright = args.bg_bright
  color.fg_bright = args.fg_bright

  local color_def = { bold = color.bold, fg_color = color.fg_color, bg_color = color.bg_color, fg_bright = color.fg_bright, bg_bright = color.bg_bright }

  local color_hl = make_color_hl(color_def)
  local color_text = make_color_text(color_def)

  color.name = color_hl
  color.text = color_text
  color.color = { items = { { name = color_hl } } }
end

local colors_view =
{
  title = " Colors ",
  items = nil,
  start = 1,
  cursor = 1,
  hide_name = true,
  color_text = true,
  chords = {},
  update = function(self)
    self.items = data.colors
  end 
}
make_chord{ chords = colors_view.chords, chord = 'b', text = 'Background color #', func = function() change_current_color{ bg_color = input.number; bg_bright = false }; input.number = -1 end }
make_chord{ chords = colors_view.chords, chord = 'B', text = 'Background color # bright', func = function() change_current_color{ bg_color = input.number; bg_bright = true }; input.number = -1 end }
make_chord{ chords = colors_view.chords, chord = 'f', text = 'Foreground color #', func = function() change_current_color{ fg_color = input.number; fg_bright = false }; input.number = -1 end }
make_chord{ chords = colors_view.chords, chord = 'F', text = 'Foreground color # bright', func = function() change_current_color{ fg_color = input.number; fg_bright = true }; input.number = -1 end }
make_chord{ chords = colors_view.chords, chord = 'h', text = 'Toggle bold', func = function() change_current_color{ toggle_bold = true } end }

--- Chords

local chords_view =
{
  title = " Chords ",
  items = chords,
  update = function(self)
    self.items = display.view.chords or chords 
  end 
}

local chords_list_view = 
{
  title = " List: ",
  update = function(self) self.items = filter(chords, function(it) return string.sub(it.name, 1, 1) == 'l' end) end 
}

--- Select

local select_list_view = 
{
  title = " Select: ",
  update = function(self) self.items = filter(chords, function(it) return string.sub(it.name, 1, 1) == 's' end) end 
}

--- Items

local people_view = 
{
  title = ' People ',
  items = nil,
  start = 1,
  cursor = 1,
  color_name = true,
  update = function(self) self.items = data.people end
}

local tasks_view = 
{
  title = ' Tasks ',
  items = nil,
  start = 1,
  cursor = 1,
  hide_name = true,
  update = function(self) self.items = data.tasks end
}

local customers_view =
{  
  title = ' Customers ',
  items = nil,
  start = 1,
  cursor = 1,
  color_name = true,
  update = function(self) self.items = data.customers end
}

local milestones_view =
{  
  title = ' Milestones ',
  items = nil,
  start = 1,
  cursor = 1,
  color_name = true,
  update = function(self) self.items = data.milestones end
}

local drones_view =
{  
  title = ' Drones ',
  items = nil,
  start = 1,
  cursor = 1,
  color_name = true,
  update = function(self) self.items = data.drones end
}

--- Labels

local labels_view =
{  
  title = ' Labels ',
  items = nil,
  start = 1,
  cursor = 1,
  color_name = true,
  update = function(self) self.items = data.labels end
}


-- Chords

make_chord{chord = '?', func = function() set_current_screen(function() show_view(chords_view) end) end, text = "Show chords help"}
make_chord{chord = '<^H>', func = function() set_current_screen(function() show_items("Chords", chords) end) end, text = "Show chords help"}
make_chord{text = '--------------------------------------------'}
make_chord{chord = 'q', func = nil, text = "Quit", continue = true}
make_chord{chord = 'qq', func = save_and_quit, text = "Save and quit"}
make_chord{chord = '<^Q>', func = save_and_quit, text = "Save and quit"}
make_chord{chord = 'Z', func = nil, text = "Save and quit...", continue = true}
make_chord{chord = 'ZZ', func = save_and_quit, text = "...Vim style"}
make_chord{chord = 'q!', func = quit_no_save, text = "Quit without saving"}
make_chord{chord = '<^S>', func = save_data, text = "Save data"}
make_chord{chord = '<^O>', func = load_data, text = "Load data"}
make_chord{text = '--------------------------------------------'}
make_chord{chord = 'l', func = function() set_current_screen(function() show_view(chords_list_view) end) end, text = "List", continue = true}
make_chord{chord = 'lp', func = function() set_current_screen(function() show_view(people_view) end) end, text = "List people"}
make_chord{chord = 'lt', func = function() set_current_screen(function() show_view(tasks_view) end) end, text = "List tasks"}
make_chord{chord = 'lc', func = function() set_current_screen(function() show_view(customers_view) end) end, text = "List customers"}
make_chord{chord = 'lm', func = function() set_current_screen(function() show_view(milestones_view) end) end, text = "List milestones"}
make_chord{chord = 'ld', func = function() set_current_screen(function() show_view(drones_view) end) end, text = "List drones"}
make_chord{chord = 'll', func = function() set_current_screen(function() show_view(labels_view) end) end, text = "List labels"}
make_chord{chord = 'lC', func = function() set_current_screen(function() show_view(colors_view) end) end, text = "List colors"}
make_chord{text = '--------------------------------------------'}
make_chord{chord = '<DOWN>', func = function() scroll{ by = 1 } end, text = 'Scroll up'}
make_chord{chord = '<UP>', func = function() scroll{ by = -1 } end, text = 'Scroll down'}
make_chord{chord = '<PGDOWN>', func = function() scroll{ by = display.list_count } end, text = 'Scroll page up'}
make_chord{chord = '<PGUP>', func = function() scroll{ by = -display.list_count } end, text = 'Scroll page down'}
make_chord{chord = '<HOME>', func = function() scroll{ to = 1 } end, text = 'First item'}
make_chord{chord = '<END>', func = function() scroll{ to = #display.view.items } end, text = 'Last item'}
make_chord{text = '--------------------------------------------'}
make_chord{chord = 'i', func = function() insert_item(0) end, text = 'Insert item above'}
make_chord{chord = 'A', func = function() insert_item(1) end, text = 'Insert item below'}
make_chord{chord = 'y', func = nil, text = 'Yank...', continue = true}
make_chord{chord = 'yy', func = function() yank_current_item() end, text = 'Yank current item'}
make_chord{chord = 'd', func = nil, text = 'Delete...', continue = true}
make_chord{chord = 'dd', func = function() delete_current_item() end, text = 'Delete current item'}
make_chord{chord = 'p', func = function() paste_item() end, text = 'Paste item before'}
make_chord{chord = 'P', func = function() paste_item(1) end, text = 'Paste item after'}
make_chord{chord = 'm', func = function() move_item(1); input.number = -1; input.last_number = -1 end, text = 'Move item down/to #'}
make_chord{chord = 'M', func = function() move_item(-1) end, text = 'Move item up'}
make_chord{text = '--------------------------------------------'}
make_chord{chord = 'e', func = function() end, text = 'Edit', continue = true}
make_chord{chord = 'ea', func = function() edit_all_in_vim() end, text = 'Edit all in Vim'}
make_chord{chord = 'en', func = function() edit_current_item'name' end, text = 'Edit name in Vim'}
make_chord{chord = 'et', func = function() edit_current_item'text' end, text = 'Edit text in Vim'}
make_chord{chord = 'E', func = function() edit_current_item'text' end, text = 'Edit text in Vim'}
make_chord{text = '--------------------------------------------'}
make_chord{chord = '/', func = function() input.in_search = true; input.search_str = '' end, text = 'Search'}
make_chord{chord = '<ENTER>', func = function() handle_enter() end, text = 'Do search! / Accept selection'}
make_chord{chord = '<ESC>', func = function() input.search_str = ''; input.in_search = false end, text = 'Escape...', continue = true}
make_chord{chord = '<ESC><ESC>', func = function() handle_escape() end, text = 'Escape!'}
make_chord{chord = '<ESC>[', func = function() end, text = 'Arrow hold...', continue = true}
make_chord{chord = '<ESC>[A', func = function() end, text = 'Arrow up hold...'}
make_chord{chord = '<ESC>[B', func = function() end, text = 'Arrow down hold...'}
make_chord{chord = '<ESC>[C', func = function() end, text = 'Arrow right hold...'}
make_chord{chord = '<ESC>[D', func = function() end, text = 'Arrow left hold...'}
make_chord{chord = '<ESC>[H', func = function() end, text = 'Home hold...'}
make_chord{chord = '<ESC>[F', func = function() end, text = 'End hold...'}
make_chord{chord = 'g', func = function() if input.last_number ~= -1 then current_chord = ''; scroll{ to = input.last_number }; input.number = -1; input.last_number = -1 end end, text = 'Go to item #', true}
make_chord{text = '--------------------------------------------'}
make_chord{chord = ' ', func = function() choose_items() end, text = 'Choose item(s)'}
make_chord{chord = 's', func = function() end, text = 'Select', continue = true}
make_chord{chord = 'sp', func = function() select_person() end, text = 'Select person'}
make_chord{chord = 'sc', func = function() select_customer() end, text = 'Select customer'}
make_chord{chord = 'sd', func = function() select_drone() end, text = 'Select drone'}
make_chord{chord = 'sl', func = function() select_label() end, text = 'Select label'}
make_chord{text = '--------------------------------------------'}
make_chord{chord = 'C', func = function() color_item() end, text = 'Color current item'}
make_chord{chord = '<^C>', func = function() set_current_screen(function() hl.printColorTable() end) end, text = 'Print color table'}

-- ------------------------------------------------------------------------------------------------------------------------

-- Parse command line

local function parse_cmdline(args)
  local param = ''

  for _, opt in ipairs(args) do
    pp(opt)
    if param == '' then 
      param = opt
    else
      if param == '-P' or param == '--project' then
        project.dir = opt .. path_separator
      end
      if param == '--print' then
        print(opt)
      end

      param = ''
    end
  end
end

-- Main loop
print"\27[60T"
print(hl.SaveScreen()())


parse_cmdline(arg)

do
  local key = -1
  local chord = nil

  load_data()

  while true do

    display.show_border = show_border
    display.show_header = show_header
    display.show_status = function() show_status(); show_keystatus() end

    xpcall(display.draw,
      function(err)
        print()
        print(hl.Bold() .. hl.Red() .. "CRASH ON DISPLAY!" .. hl.Off())
        print(err)
	inkey()
      end)

    if key == -1 then
      -- Startup chord - because we can!
    else
      key = inkey()
    end

    status_text = ''

    local chars

    if key == -1 then
      -- Startup chord - yes, it's an ugly hack, but will do for now
      chars = 'lt' -- List tasks
      key = 0
    else
      chars = chars_for(key)
    end

    local view_chords = nil
    if display.view.chords then
      view_chords = display.view.chords
    end
    chord = chord_for(chars, chords, view_chords)

    if chord ~= nil then
      local func = chord.func
      if func ~= nil then
        xpcall(func,
          function(err)
            print()
            print(hl.Bold() .. hl.Red() .. "CRASH ON FUNCTION!" .. hl.Off())
            print(err)
            inkey()
	  end)
       end
    end  

    local hlKey = hl.Bold() .. hl.BrightGreen() .. hl.BgBlack()
    keystatus_text = "Chord .. [" .. hlKey .. last_chord .. hlKeyStatus .. "] Key [" .. hlKey .. tostring(key) .. hlKeyStatus .. "]"
    if input.number ~= -1 then keystatus_text = keystatus_text .. " Number [" .. hlKey .. tostring(input.number) .. hlKeyStatus .. "]" end
    if input.in_search then keystatus_text = keystatus_text .. " Search [" .. hlKey .. input.search_str .. hlKeyStatus .."]" end

  end
end


