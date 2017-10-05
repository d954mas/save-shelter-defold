local constants = require("pseudo.modules.constants")

local M={}
local wall_color = string.char(0x00) .. string.char(0x00) .. string.char(0x00)
local empty_color = string.char(0xff) .. string.char(0xff) .. string.char(0xff)
local player_position = vmath.vector3(0)
local rotation = vmath.vector3(0)

local function create_texture(map) 
	local map_width = map:get_width()
	local map_height = map:get_height()
	local pixels = ""
	
	local potY=math.ceil(math.log(map:get_height())/math.log(2))
	local dy=math.pow(2,potY) - map:get_height()
	
	local potX=math.ceil(math.log(map:get_width())/math.log(2))
	local dx= math.pow(2,potX) - map:get_width()
	
	for y=1, math.pow(2,potY) do
		for x=1, math.pow(2,potX) do
			if (y>=dy/2+1 and y<(map:get_height()+dy/2+1)) and
				(x>=dx/2+1 and x<map:get_width()+dx/2+1)
			then
			
				local cell_color = map:get_wall(x-dx/2,y-dy/2).texture and wall_color or empty_color
				pixels = pixels .. cell_color	
			else
				pixels = pixels .. wall_color	
			end		
		end
	end
	return gui.new_texture("map", math.pow(2,potX), math.pow(2,potY), "rgb",pixels,true)	
end

function M.change_map(map)
	if(create_texture(map))then
		 gui.set_texture(M.node, "map")
	else
		assert("can't create texture for map")
	end	
end	

function M.init()
	M.node = gui.get_node("minimap/minimap")
	M.player_node = gui.get_node("minimap/player")
	gui.set_enabled(M.node,false)
end

function M.update(world)
	player_position.x=(world.player.pos.x -world.map:get_width()/2)
	player_position.y=(world.player.pos.y -world.map:get_height()/2)
	rotation.z=world.player.angle * 57.2958
	gui.set_position(M.player_node,player_position)
	gui.set_rotation(M.player_node,rotation)
end


function M.show()
	gui.set_enabled(M.node,true)
end

function M.hide()
	gui.set_enabled(M.node,false)
end	
return M