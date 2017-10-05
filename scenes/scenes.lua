local M = {}
local prefix = "main:/scenes"

local function create_url(name)
	return msg.url(prefix .. name)
end

M.intro = create_url("#intro")
M.game = create_url("#game")
M.game_over = create_url("#game_over")	
M.win = create_url("#win")	
M.default_scene_name = "intro"

return M