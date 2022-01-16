-- Storing and loading project data

-- Storage #1: project directory with one file for each item type
-- I.e.:
-- ./People.lua
-- ./Tasks.lua
-- ..

local serpent = require'serpent'

local serdes = {}

serdes.dir = {}

local people_filename = 'People.lua'
local tasks_filename = 'Tasks.lua'
local customers_filename = 'Customers.lua'
local milestones_filename = 'Milestones.lua'
local drones_filename = 'Drones.lua'

local all_filenames = 
{
people_filename,
tasks_filename,
customers_filename,
milestones_filename,
drones_filename,
}

-- Editing in Vim

local function get_all_full_filenames(dir)
  local t = {}

  for _, filename in ipairs(all_filenames) do
    table.insert(t, dir .. filename)
  end

  return table.concat(t, " ")
end

local function get_vim_cmdline(dir)
  return "vim "
    .. " -p " .. get_all_full_filenames(dir)
end

-- Loading and saving files

local function load_file(file)
  local f, err = io.open(file, "r")

  if f == nil then
    return false, err
  end

  local s = f:read("*a")
  f:close()

  local res, o = serpent.load(s)
  if not res then return res, o end

  return true, o
end

local function save_file(file, o)
  local f, err = io.open(file, "w+")

  if f == nil then
    return false, err
  end

  local s = serpent.block(o, { comment = false, sparse = true })

  local content = f:write(s)
  f:close()

  return true
end

local function load_dir(dir)
  local res = true
  local people, tasks, customers, milestones, drones

  res, people = load_file(dir .. people_filename)
  if not res then people = nil end
  -- if not res then return res, people end

  res, tasks = load_file(dir .. tasks_filename)
  if not res then tasks = nil end
  -- if not res then return res, tasks end

  res, customers = load_file(dir .. customers_filename)
  if not res then customers = nil end
  -- if not res then return res, customers end

  res, milestones = load_file(dir .. milestones_filename)
  if not res then milestones = nil end
  -- if not res then return res, milestones end

  res, drones = load_file(dir .. drones_filename)
  if not res then drones = nil end
  -- if not res then return res, drones end

  local data = {}
  data.people = people
  data.tasks = tasks
  data.customers = customers
  data.milestones = milestones
  data.drones = drones

  -- Fixup references

  return true, data
end

local function save_dir(dir, data)
  -- Unfixup references

  local res, err

  res, err = save_file(dir .. people_filename, data.people)
  if not res then return res, err end

  res, err = save_file(dir .. tasks_filename, data.tasks)
  if not res then return res, err end

  res, err = save_file(dir .. customers_filename, data.customers)
  if not res then return res, err end

  res, err = save_file(dir .. milestones_filename, data.milestones)
  if not res then return res, err end

  res, err = save_file(dir .. drones_filename, data.drones)
  if not res then return res, err end

  -- Fixup references back

  return true
end


serdes.load_dir = load_dir
serdes.save_dir = save_dir
serdes.get_vim_cmdline = get_vim_cmdline

return serdes
