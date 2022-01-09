-- Storing and loading project data

-- Storage #1: project directory with one file for each item type
-- I.e.:
-- ./People.lua
-- ./Tasks.lua
-- ..

local serdes = {}

serdes.dir = {}

local people_filename = 'People.lua'
local tasks_filename = 'Tasks.lua'

local function dir_save(dir, filename, o)
  
end

local function load_file(file)
    local f = assert(io.open(file, "r"))
    local content = f:read("*a")
    f:close()
    return content
end

local function save_file(file, content)
    local f = assert(io.open(file, "w+"))
    local content = f:write(content)
    f:close()
    return content
end

local function dir_save_people(dir, people)
  
end

local function dir_load_people(filename)
end


local function load_dir(dir)
  local people = load_file(dir .. people_filename)
  local tasks = load_file(dir .. tasks_filename)

  local data = {}
  data.people = people
  data.tasks = tasks

  -- Fixup references

  return data
end

local function save_dir(dir, data)
  -- Unfixup references

  save_file(dir .. people_filename, data.people)
  save_file(dir .. tasks_filename, data.tasks)

  -- Fixup references back
end


serdes.load_dir = load_dir
serdes.save_dir = save_dir

return serdes
