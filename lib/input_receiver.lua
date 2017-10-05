local M = {}
M.__index = M

local function ensure_hash(string_or_hash)
	return type(string_or_hash) == "string" and hash(string_or_hash) or string_or_hash
end

function M.new()
	local self = setmetatable({}, M)
	self.action_funs = {}
	return self
end

function M:add(action_id,fun)
	local action_id = ensure_hash(action_id)
	assert(not self.action_funs[action_id], action_id .. " already used")
	self.action_funs[action_id] = fun
end	

function M:on_input(go_self, action_id, action)
	local fun = self.action_funs[action_id]
	if fun then
		fun(go_self, action_id, action)
		return true
	end
	return false	
end	
return M
