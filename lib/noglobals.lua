_globals = {}

local _set = function(_g, k)
	if _globals[k] ~= nil then
		return _globals[k]
	else
		print("Undeclared globals not allowed: " .. (k or ""))
		assert(false)
	end
end

local _new = function(_g, k)
	if _globals[k] ~= nil then
		return _globals[k]
	else
		print("New globals not allowed: " .. (k or ""))
		assert(false)
	end
end

local global = function(name, v)
	v = v or {}
	_globals[name]  = v
end 

_G.global = global

_G = setmetatable(_G, { __index = _set, __newindex = _new });

 
