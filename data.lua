-- Data Model
local genid = require'genid'

local data = {}

local Type = 
{
  Person = 'PERSON',
  Task = 'TASK',
  Customer = 'CUSTOMER',
  Milestone = 'MILESTONE',
  Drone = 'DRONE',
  Label = 'LABEL',

}

local people = 
{ 
  type = Type.Person,
  related =
  {
    labels =
    {
      multiple = true,
      items = {}
    }
  }
}

local tasks = 
{ 
  type = Type.Task,
  related =
  {
    labels =
    {
      multiple = true,
      items = {}
    },
    people = 
    {
      multiple = false,
      items = {}
    },
    drones =
    {
      multiple = true,
    },
    customers =
    {
      multiple = true,
      items = {}
    },
    milestones =
    {
      multiple = true,
      items = {}
    }
  }
}

local customers = 
{ 
  type = Type.Customer,
  related =
  {
    labels =
    {
      multiple = true,
      items = {}
    }
  }
}

local milestones =
{
  type = Type.Milestone,
  related =
  {
    labels =
    {
      multiple = true,
      items = {}
    },
    customers =
    {
      multiple = false,
      items = {}
    },
    drones =
    {
      multiple = true,
      items = {}
    }
  }
}

local drones = 
{ 
  type = Type.Drone,
  related =
  {
    labels =
    {
      multiple = true,
      items = {}
    }
  }
}

local labels = 
{ 
  type = Type.Label,
  related =
  {
  }
}

data.Type = Type

data.people = people
data.tasks = tasks
data.customers = customers
data.milestones = milestones
data.drones = drones
data.labels = labels

-- Data Base

--[[

local p, t, c, m, d

--- People

p =
{
  id = genid(),
  name = 'RP',
  text = 'Roman Pavlyuk, CTO, a very inteligent and self-loving human being, a dream of every woman'
}
table.insert(people, p)

p =
{
  id = genid(),
  name = 'AL',
  text = 'Anton Lutsyshyn, let the moon shine and let the circuits blow!'
}
table.insert(people, p)


--- Tasks

t =
{
  id = genid(),
  text = 'Gimbal',
  assigned_to = p,
}
table.insert(tasks, t)

for i=1,10000 do
  t =
  {
    id = genid(),
    text = 'Task #' .. tostring(i+1) .. ": this is a very important task, a very long line, and overall life is suffering and we all shall eventually die",
    assigned_to = p,
  }
  table.insert(tasks, t)
end


-- local t_ser = serpent.dump(t)
-- pp"======= TASK ==================================="
-- print(t_ser)
-- pp"================================================"

]]--

return data
