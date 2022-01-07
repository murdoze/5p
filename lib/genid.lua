local function genid()
  -- os.execute'sleep 1'
  return "id_" .. os.date('!%Y%m%dT%H%M%S', os.time()) .. "_" .. math.random(100000000, 999999999)
end

return genid
