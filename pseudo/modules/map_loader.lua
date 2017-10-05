local OBJECTS = require("pseudo.modules.models.objects")
local PICKUPS = require("pseudo.modules.models.pickups")
local ENEMIES = require("pseudo.modules.models.enemies")

local M = {}

--region light map
local function hex2rgb(value)
	local r=tonumber("0x"..value:sub(3,4))/255
	local g=tonumber("0x"..value:sub(5,6))/255
	local b=tonumber("0x"..value:sub(7,8))/255
	return vmath.vector4(r,g,b,1)
end
local LIGHT_MAP=json.decode(sys.load_resource"/assets/maps/light_map.json")
for i,light in ipairs(LIGHT_MAP.light_map)do
	LIGHT_MAP.light_map[i]=hex2rgb(light)
end
--endregion light map

--region map object
local Map = {}
Map.__index = Map

function Map.new(data)
	local self = setmetatable({}, Map)
	self.data=data
	return self
end

function Map:get_wall(x,y)
	assert(x<=self.data.width and x>=1,"bad x:"..x)
	assert(y<=self.data.height and y>=1,"bad y:"..y)
	return self.data.walls[self.data.height - y + 1][x]
end

function Map:get_width()
	return self.data.width
end

function Map:get_height()
	return self.data.height
end
--endregion map

local function find_layer(layers,name)
	for i,layer in ipairs(layers)do
		if(layer.name == name) then
			return layer
		end
	end
	assert("unknown layer:"..name)
end

local function parse_tiles(layer_data,width,height,firstgid,provider,light_map)
	local tiles={}
	for y=1, height do
		tiles[y]={}
		local reverse_y=height-y+1
		for x=1,width do
			local tile=layer_data[(y-1)*width + x]
			tile = tile==0 and 0 or tile-firstgid
			if(provider) then tile = provider(tile, x, y, reverse_y, width, height, layer_data, light_map) end
			tiles[y][x]=tile
		end
	end
	return tiles
end

local function to_objects_array(tiles)
	local height = #tiles
	local width = #tiles[1]
	local result = {}
	for y=1, height do
		for x=1, width do
			local tile = tiles[y][x]
			if(tile ~= 0) then table.insert(result,tile) end
		end
	end
	return result
end

local function parse_object(object,height,size)
	local x,y = object.x/size, height - object.y/size -1
	local object_width, object_height = object.width/size, object.height/size
	return {x=x,y=y,width=object_width,height=object_height}
end

local function parse_geometry(objects,height,size)
	local result={}
	for i,object in ipairs(objects) do
		result[i]=parse_object(object,height,size)
	end
	return result
end

local function parse_sounds_3d(objects,height,size)
	local result={}
	for i,object in ipairs(objects) do
		result[i]=parse_object(object,height,size)
		result[i].sound=object.properties.sound
	end
	return result
end

local function parse_enemies(objects,height,size)
	local result={}
	for i,object in ipairs(objects) do
		local enemie=parse_object(object,height,size)
		enemie.data=ENEMIES[object.type]
		result[i]=enemie
	end
	return result
end

local function parse_player(player,height,size)
	return parse_object(player[1], height, size)
end

local lights = {}
--region providers
local function light_map_provider(tile,x,y,reverse_y,width,height,tiles,light_map)
	lights[tile] = lights[tile] and lights[tile] + 1 or 1
return tile~=0 and {light=LIGHT_MAP.light_map[tile], id = tile} or nil
end

local function model_map_provider(tile,x,y,reverse_y,width,height,tiles,light_map,model_map)
	if(tile~=0) then
		local object={}
		object.data=model_map[tile]
		object.x, object.y = x, reverse_y
		return object
	else
		return 0
	end
end

local function objects_provider(tile,x,y,reverse_y,width,height,tiles,light_map)
	return model_map_provider(tile,x,y,reverse_y,width,height,tiles,light_map,OBJECTS.MAP)
end

local function pickups_provider(tile,x,y,reverse_y,width,height,tiles,light_map)
	return model_map_provider(tile,x,y,reverse_y,width,height,tiles,light_map,PICKUPS.MAP)
end

local function floor_provider(tile,x,y,reverse_y,width,height,tiles,light_map)
	if(tile~=0) then
		local floor={}
		floor.texture=hash("wall"..tile)
		floor.x, floor.y = x, reverse_y
		floor.light=light_map[y][x]
		return floor
	else
		return 0
	end
end

local function is_sprite_visible(next_x,next_y,walls,width,height)
	return (next_x<=width and next_x>=1)
	and (next_y<=height and next_y>=1)
	and walls[(next_y-1)*width + next_x]==0
end

local function get_wall_light(x,y,width,height,light_map)
	return ((x<=width and x>=1) and (y<=height and y>=1)) and light_map[y][x] or nil
end

local function wall_provider(tile,x,y,reverse_y,width,height,tiles,light_map)
	local wall={}
	if(tile~=0)then
		wall.texture=hash("wall"..tile)
		wall.visible_left=is_sprite_visible(x-1,y,tiles,width,height)
		wall.visible_right=is_sprite_visible(x+1,y,tiles,width,height)
		wall.visible_top=is_sprite_visible(x,y-1,tiles,width,height)
		wall.visible_bottom=is_sprite_visible(x,y+1,tiles,width,height)

		wall.light_left=get_wall_light(x-1,y,width,height,light_map)
		wall.light_right=get_wall_light(x+1,y,width,height,light_map)
		wall.light_top=get_wall_light(x,y-1,width,height,light_map)
		wall.light_bottom=get_wall_light(x,y+1,width,height,light_map)
	end
	return wall
end


function M.load(map_path)
	local data = json.decode(sys.load_resource(map_path))
	local tile_size, layers = data.tileheight, data.layers
	local width, height = data.width, data.height
	local map={width=width,height=height}
	
	local row_walls=0
	local row_objects=12
	local row_light_map=23
	local row_pickups=140

	map.light_map = parse_tiles(find_layer(layers,"light_map").data, width, height,row_light_map,light_map_provider)
	map.objects = to_objects_array(parse_tiles(find_layer(layers,"objects").data, width, height,row_objects,objects_provider))
	map.floors = to_objects_array(parse_tiles(find_layer(layers,"floor").data, width, height, row_walls, floor_provider, map.light_map))
	map.ceils = to_objects_array(parse_tiles(find_layer(layers,"ceil").data, width, height, row_walls, floor_provider, map.light_map))
	map.pickups = to_objects_array(parse_tiles(find_layer(layers,"pickups").data,width,height,row_pickups,pickups_provider))
	map.walls=parse_tiles(find_layer(layers,"walls").data, width, height, row_walls, wall_provider, map.light_map)
	
	map.geometry=parse_geometry(find_layer(layers,"geometry").objects,height,tile_size)
	map.player=parse_player(find_layer(layers,"player").objects,height,tile_size)
	map.enemies=parse_enemies(find_layer(layers,"enemies").objects,height,tile_size)
	map.sounds_3d=parse_sounds_3d(find_layer(layers,"sounds_3d").objects,height,tile_size)
	pprint(lights)
	pprint(LIGHT_MAP.light_map[39])
	return Map.new(map)
end

function M.generate()
	return M.parse_map()
end

return M
