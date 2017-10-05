local constants = require("pseudo.modules.constants")
local map_loader = require("pseudo.modules.map_loader")
local M = {}

M.player = require("pseudo.modules.world.player.player")

function M.load_map(map)
  M.map=map_loader.load("/assets/maps/level1.json")
--  pprint(astar.find_path({x=2,y=19},{x=2,y=19}))
end

return M
