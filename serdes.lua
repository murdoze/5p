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

local function dir_save(dir, filename, o)
  
end

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
  local people, tasks 

  res, people = load_file(dir .. people_filename)
  if not res then return res, people end

  res, tasks = load_file(dir .. tasks_filename)
  if not res then return res, tasks end

  local data = {}
  data.people = people
  data.tasks = tasks

  -- Fixup references

  return true, data
end

local function save_dir(dir, data)
  -- Unfixup references

  local res, err

  res, err = save_file(dir .. people_filename, data.people)
  if not res then
    return res, err
  end

  res, err = save_file(dir .. tasks_filename, data.tasks)
  if not res then
    return res, err
  end

  -- Fixup references back

  return true
end


serdes.load_dir = load_dir
serdes.save_dir = save_dir

return serdes
