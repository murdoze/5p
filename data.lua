-- Data Model
local genid = require'genid'

local data = {}

local Item = 
{
  Person = 'PERSON',
  Task = 'TASK',
  Customer = 'CUSTOMER',
  Milestone = 'MILESTONE',
  Drone = 'DRONE',

}

local people = {}
local tasks = {}
local customers = {}
local milestones = {}
local drones = {}

data.Item = Item

data.people = people
data.tasks = tasks
data.customers = customers
data.milestones = milestones
data.drones = drones

-- Data Base

local p, t, c, m, d

--- People

p =
{
  id = genid(),
  item = Item.Person,
  name = 'RP',
  text = 'Roman Pavlyuk, CTO, a very inteligent and self-loving human being, a dream of every woman'
}
table.insert(people, p)

p =
{
  id = genid(),
  item = Item.Person,
  name = 'AL',
  text = 'Anton Lutsyshyn, let the moon shine and let the circuits blow!'
}
table.insert(people, p)


--- Tasks

t =
{
  id = genid(),
  item = Item.Task,
  text = 'Gimbal',
  assigned_to = p,
}
table.insert(tasks, t)

for i=1,10000 do
  t =
  {
    id = genid(),
    item = Item.Task,
    text = 'Task #' .. tostring(i+1) .. ": this is a very important task, a very long line, and overall life is suffering and we all shall eventually die",
    assigned_to = p,
  }
  table.insert(tasks, t)
end


-- local t_ser = serpent.dump(t)
-- pp"======= TASK ==================================="
-- print(t_ser)
-- pp"================================================"

return data
