-- ======================================================================
-- Copyright (c) 2012 RapidFire Studio Limited 
-- All Rights Reserved. 
-- http://www.rapidfirestudio.com

-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ======================================================================
----------------------------------------------------------------
-- local variables
----------------------------------------------------------------

local INF = 1/0
local cachedPaths = nil

----------------------------------------------------------------
-- local functions
----------------------------------------------------------------

local function dist (x1, y1, x2, y2)
	return math.sqrt(math.pow(x2 - x1, 2) + math.pow (y2 - y1, 2))
end

local function dist_between(nodeA, nodeB)
	return dist(nodeA.x, nodeA.y, nodeB.x, nodeB.y)
end

local function heuristic_cost_estimate ( nodeA, nodeB )
	return dist (nodeA.x, nodeA.y, nodeB.x, nodeB.y)
end

local function is_valid_node (node, neighbor)
	if distance(node.x, node.y, neighbor.x, neighbor.y) <=1 then
		return true
	end
	return false
end

local function lowest_f_score (set, f_score)
	local lowest, bestNode = INF, nil
	for _, node in ipairs ( set ) do
		local score = f_score [ node ]
		if score < lowest then
			lowest, bestNode = score, node
		end
	end
	return bestNode
end

local function neighbor_nodes (theNode, nodes)
	local neighbors = {}
	for _, node in ipairs (nodes) do
		if theNode ~= node and is_valid_node (theNode, node) then
			table.insert (neighbors, node)
		end
	end
	return neighbors
end

local function not_in ( set, theNode )
	for _, node in ipairs ( set ) do
		if node == theNode then return false end
	end
	return true
end

local function remove_node ( set, theNode )
	for i, node in ipairs ( set ) do
		if node == theNode then 
			set [ i ] = set [ #set ]
			set [ #set ] = nil
			break
		end
	end	
end

local function unwind_path ( flat_path, map, current_node )
	if map [ current_node ] then
		table.insert ( flat_path, 1, map [ current_node ] ) 
		return unwind_path ( flat_path, map, map [ current_node ] )
	else
		return flat_path
	end
end

----------------------------------------------------------------
-- pathfinding functions
----------------------------------------------------------------

local function a_star(start, goal, nodes, valid_node_func)
	local closedset = {}
	local openset = { start }
	local came_from = {}

	if valid_node_func then is_valid_node = valid_node_func end

	local g_score, f_score = {}, {}
	g_score [ start ] = 0
	f_score [ start ] = g_score [ start ] + heuristic_cost_estimate ( start, goal )

	while #openset > 0 do
	
		local current = lowest_f_score ( openset, f_score )
		if current == goal then
			local path = unwind_path ( {}, came_from, goal )
			table.insert ( path, goal )
			return path
		end

		remove_node ( openset, current )		
		table.insert ( closedset, current )
		
		local neighbors = neighbor_nodes ( current, nodes )
		for _, neighbor in ipairs ( neighbors ) do 
			if not_in ( closedset, neighbor ) then
			
				local tentative_g_score = g_score [ current ] + dist_between ( current, neighbor )
				 
				if not_in ( openset, neighbor ) or tentative_g_score < g_score [ neighbor ] then 
					came_from 	[ neighbor ] = current
					g_score 	[ neighbor ] = tentative_g_score
					f_score 	[ neighbor ] = g_score [ neighbor ] + heuristic_cost_estimate ( neighbor, goal )
					if not_in ( openset, neighbor ) then
						table.insert ( openset, neighbor )
					end
				end
			end
		end
	end
	return nil -- no valid path
end

----------------------------------------------------------------
-- exposed functions
----------------------------------------------------------------

function clear_cached_paths ()

	cachedPaths = nil
end

function distance ( x1, y1, x2, y2 )
	
	return dist ( x1, y1, x2, y2 )
end

function path ( start, goal, nodes, ignore_cache, valid_node_func )

	if not cachedPaths then cachedPaths = {} end
	if not cachedPaths [ start ] then
		cachedPaths [ start ] = {}
	elseif cachedPaths [ start ] [ goal ] and not ignore_cache then
		return cachedPaths [ start ] [ goal ]
	end
	
	return a_star ( start, goal, nodes, valid_node_func )
end



local M = {}
M.nodes = {}

local function parse_nodes(map)
	local nodes = {}
	local height = #map
	for y=1, height do
		for x=1,#map[1] do
			local wall=map[y][x]
			if(not wall.texture)then
				table.insert(nodes,{x=x-0.5,y=height-y+1-0.5})
			end	
		end	
	end
	return nodes
end

local function find_node(x,y)
	for _,node in ipairs(M.nodes) do
		if(node.x==x and node.y==y )then
			return node	
		end	
	end
	return nil
end	

function M.init(map)
	M.nodes = parse_nodes(map)
end

function M.find_path(start_x,start_y,end_x,end_y,ignore_cached)
	local start_node=find_node(math.ceil(start_x)-0.5,math.ceil(start_y)-0.5)
	local end_node=find_node(math.ceil(end_x)-0.5,math.ceil(end_y)-0.5)
	return path(start_node,end_node,M.nodes,ignore_cached)
end	

return M