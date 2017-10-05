--http://lodev.org/cgtutor/raycasting.html
local constants = require("pseudo.modules.constants")
local world = require ("pseudo.modules.world.world")
local map = world.map_geometry
local player = world.player
local lume = require("lib.lume")
local M = {}

local sin = math.sin
local cos = math.cos
local floor = math.floor
local ceil = math.ceil
local abs = math.abs

M.half_fov = constants.PLAYER_FOV/2
M.twoPI = 3.1415 * 2;
M.ray_angle = constants.PLAYER_FOV/constants.PLAYER_RAYS

local function draw_ray(x,y)
	x = x - map.get_width()/2
	y = y - map.get_height()/2
	local scale = 32/map.get_width()*5
	msg.post("@render:", "draw_line", { start_point = M.minimap_pos + M.player_pos, end_point = M.minimap_pos + vmath.vector3(x * scale , y * scale , 0), color = vmath.vector4(1, 0, 0, 1)}) 
end

--count sx and step. same logic for x and y
local function count_sx_and_step(dx,map_x,x,abs_dx)
	local sx, step_x
	if(dx>0) then
		sx = (map_x - x) * abs_dx
		step_x = 1
	else
		sx = (1 + x  - map_x) * abs_dx
		step_x = - 1
	end
	return sx, step_x
end
	
local function find_ray_intersept(x,y,angle,cells)
	local map_x = ceil(x)
    local map_y = ceil(y)
    
    local angle_sin=-math.sin(angle)
    local angle_cos=math.cos(angle)
    
	local dx = 1/angle_sin
	local dy =  1/angle_cos
	
	local abs_dx = abs(dx)
	local abs_dy = abs(dy)
	
	--print("dx:" .. dx .. "dy:" .. dy)
	local sx, step_x = count_sx_and_step(dx,map_x,x,abs_dx)
	local sy, step_y = count_sx_and_step(dy,map_y,y,abs_dy)
      
    local move_x, move_y = 0 , 0
    local hit_x = true
   -- print("************************************")
    while(true) do
    --	print("sx:"..sx.." sy:"..sy)
    	if(sx < sy) then
			map_x = map_x + step_x
			sx = sx + abs_dx
			hit_x = true
		else
			map_y = map_y + step_y
			sy = sy + abs_dy
			hit_x = false
		end
		cells[map_y][map_x].new_visibility=true
		--print("map_x:"..map_x.." map_y:"..map_y)
		--table.insert(cells,{x=map_x,y=map_y})
		if(map.is_blocking(map_x,map_y))then
			local dist,catet_x,catet_y
			if(hit_x) then
				sx = sx - abs_dx --remove last dx
				dist = sx
		    else
				sy = sy - abs_dy --remove last dy
				dist = sy
			end
			catet_x = dist * angle_sin
			catet_y = dist * angle_cos
			return dist, x + catet_x , y + catet_y
		end	
	end	
end

--minimap_pos need to correct draw rays in minimap
function M.cast_rays(minimap_pos,player_pos,chunks_cells)
	M.minimap_pos=minimap_pos
	M.player_pos=player_pos
	local start_rot = player.angle - M.half_fov
	--local startTime = os.clock()	
	
	for i=1 , constants.PLAYER_RAYS do
		local dist,x,y = find_ray_intersept(player.pos.x,player.pos.y,start_rot + M.ray_angle * (i-1),chunks_cells)
		if(minimap_pos~=nil) then draw_ray(x,y) end
		--cast_single_ray(start_rot + M.ray_angle * (i-1))
	end
	--pprint(check_cells)
	--local endTime = os.clock()
	--print("time:".. endTime-startTime)
	return check_cells
end

return M