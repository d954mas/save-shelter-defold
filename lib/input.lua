local M = {}

local HASH_ACQUIRE = hash("acquire_input_focus")
local HASH_RELEASE = hash("release_input_focus")
--- Acquire input focus for the current script
-- @param url
function M.acquire(url)
	msg.post(url or ".", HASH_ACQUIRE)
end

--- Release input focus for the current script
-- @param url
function M.release(url)
	msg.post(url or ".", HASH_RELEASE)
end

return M