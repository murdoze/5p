-- Data Model
local genid = require'genid'

local db = {}

local data = {}
local index = {}

db.data = data
db.index = index

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
      items = {}
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

return db
