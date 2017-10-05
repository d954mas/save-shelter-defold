local M = {}

-- 0 - no collision
-- 1 - block player
-- 2 - block player and projectives

M["box"] = {texture=hash("box"),scale=0.015625, position_z =0,collision = 2}
M["table"] = {texture=hash("table"),scale=0.015625, position_z =0,collision = 1}
M["lamp"] = {texture=hash("lamp"),scale=0.015, position_z = 0.4 , collision = 0}
M["block"] = {texture=hash("block"),scale=0.015625, position_z =0,collision = 2}
M["bot_crystal"] = {texture=hash("bot_crystal"),scale=0.015625/1.5, position_z =-0.21,collision = 2}
M["bot_crystal_2"] = {texture=hash("bot_crystal_2"),scale=0.015625/1.5, position_z =-0.21,collision = 2}
M["top_crystal_1"] = {texture=hash("top_crystal_1"),scale=0.015625/3, position_z =0.25,collision = 0}
M["top_crystal_2"] = {texture=hash("top_crystal_2"),scale=0.015625/3, position_z =0.25,collision = 0}
M["mushroom"] = {texture=hash("mushroom_1"),scale=0.015625/1, position_z =-0.25,collision = 2}
M["mushroom_2"] = {texture=hash("mushroom_2"),scale=0.015625/1, position_z =-0.25,collision = 2}
M["skull"] = {texture=hash("skull"),scale=0.015625/3, position_z =-0.415,collision = 0}
M.MAP = {
	[1]=M.table,
	[2]=M.block,
	[3]=M.lamp,
    [4]=M.box,
    [5]=M.bot_crystal,
    [6]=M.bot_crystal_2,
    [7]=M.mushroom,
    [8]=M.mushroom_2,
    [9]=M.skull,
    [10]=M.top_crystal_1,
    [11]=M.top_crystal_2,
}
return M
