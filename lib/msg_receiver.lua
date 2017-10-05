local M = {}
M.__index = M

local function ensure_hash(string_or_hash)
	return type(string_or_hash) == "string" and hash(string_or_hash) or string_or_hash
end

function M.new()
	local self = setmetatable({}, M)
	self.msg_funs = {}
	return self
end

function M:add(message_id,fun)
	local message_id = ensure_hash(message_id)
	assert(not self.msg_funs[message_id], message_id .. " already used")
	self.msg_funs[message_id] = fun
end	

function M:on_message(go_self, message_id, message, sender)
	local fun = self.msg_funs[message_id]
	if fun then
		fun(go_self, message_id, message, sender)
		return true
	end
	return false	
end	
return M
