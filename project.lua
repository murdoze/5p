local pp, inkey, push = unpack(require 'lib/all')

local hl = require'highlight'
local genid = require'genid'
local nonnull = require'nonnull'
local serpent = require'serpent'

local display=require'display'


require'noglobals'



-- Data Model

local Item = 
{
  Person = 'PERSON',
  Task = 'TASK',
  Customer = 'CUSTOMER',
  Milestone = 'MILESTONE',
  Drone = 'DRONE',

}

local People = {}
local Tasks = {}

-- Data Base

local p, t, c, m, d

--- People

p =
{
  id = genid(),
  item = Item.Person,
  name = 'RP',
  text = 'Roman Pavlyuk, CTO, характєр мєрзкій, нє женат'
}
table.insert(People, p)

p =
{
  id = genid(),
  item = Item.Person,
  name = 'AL',
  text = 'Anton Lutsyshyn, фізик-самогонщик, характєр мєрзкій, нє женат'
}
table.insert(People, p)


--- Tasks

t =
{
  id = genid(),
  item = Item.Task,
  text = 'Gimbal',
  assigned_to = p,
}
table.insert(Tasks, t)


local t_ser = serpent.dump(t)
pp"======= TASK ==================================="
print(t_ser)
pp"================================================"


-- Chord processing

local current_chord = ''

local chords = {}

local function makeChord(chord, func, text, continue_chord)
  chords[chord] = { func =  func, text = text, continue = continue_chord }
end

local function charsFor(key)
  local keymap=
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

  print("==>" .. current_chord .. "<==")

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

local function show_header()
  print(hl.Locate(display.header_line, 1)())
  display.print_line(hl.White() .. hl.BgRed() .. "5p — Personal Portable Project Planning Paradise" .. hl.Off())
end

local function show_line_numbers()
  for i = display.list_begin_line,display.list_end_line do
    print(hl.Locate(i, 1)())
    display.print_line(string.format("%2d", i) .. ". ")
  end
end

local function show_status()
  print(hl.Locate(display.status_line, 1)())
  print(hl.White() .. hl.BgBlue() .. " Status normal" .. hl.Off())
end


local function showHelp()
  print(hl.Locate(15, 50)() .. "HELP !!!!")
  print('HELP !!!!!!!')
end

local function showList()
  print"LIST!!!!"
end

local function showItems(items)
  items = nonnull.list(items)

  for i, it in ipairs(items) do
    print(i .. ". " .. nonnull.value(it.name, '?UNKNOWN?') .. "\t\t" .. hl.Faint() .. nonnull.value(it.text, '') .. hl.Off())
  end
end

local function listPeople(people)
  showItems(nonnull.value(people, People))
end


local function hlRedUnderlined(s) return hl.Red() .. hl.Underline() .. s .. hl.Off() end

makeChord('?', function() set_current_screen(showHelp) end, "Show chords help")

makeChord('l', function() set_current_screen(showList) end, "List: " .. hlRedUnderlined('p') .. "eople, tasks,..", true)
makeChord('lp', function() set_current_screen(listPeople) end, "List people")
makeChord('lt', function() set_current_screen(function() showItems(Tasks) end) end, "List tasks")


do
  local key = 0
  local chars = ''
  local chord = nil

  while chars ~= 'q' do

    display.show_header = show_header
    display.show_status = show_status

    display.draw()
 
    key = inkey()
    print(hl.Cls())
 
    chars = charsFor(key)
    chord = chordFor(key)

   

    print(hl.Locate(10, 40)() .. key .. " => [" .. current_chord .. "] " .. genid())

    if chord ~= nil then
      local func = chord.func
      if func ~= nil then
        func()
        pp(chord)
      end
    end  

  end

  hl.printColorTable()

end


