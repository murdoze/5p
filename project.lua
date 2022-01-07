local pp, inkey, push = unpack(require 'lib/all')

local hl = require'highlight'
local genid = require'genid'
local nonnull = require'nonnull'

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
  text = 'Gimbal'
}
table.insert(Tasks, t)


t =
{
    id = genid()
}



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

-- Chords

local function showHelp()
  print(hl.Cls())
  print(hl.Locate(15, 50)() .. "HELP !!!!")
  print('HELP !!!!!!!')
end

local function showList()
  print(hl.Cls())
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

makeChord('?', showHelp, "Show chords help")

makeChord('l', showList, "List: " .. hlRedUnderlined('p') .. "eople, tasks,..", true)
makeChord('lp', listPeople, "List people")
makeChord('lt', function() showItems(Tasks) end, "List tasks")


do
  local key = 0
  local chars = ''
  local chord = nil

  while chars ~= 'q' do
 
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


