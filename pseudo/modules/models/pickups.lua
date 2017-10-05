local weapons = require("pseudo.modules.models.weapons")
local M = {}

M.TYPES={weapon=1,ammo=2,medkit=3,ball=4}
--M.pistol = {icon=hash("pistol_icon"),scale=0.015625,position_z = -0.4,type=M.TYPES.weapon,data=weapons.pistol}
M.nailgun = {id=4,icon=hash("nailgun_icon"),scale=0.015625,position_z = -0.4,type=M.TYPES.weapon,data=weapons.nailgun}

M.medkit = {id=1,icon=hash("medikit"),scale=0.015625, position_z =-0.4,type=M.TYPES.medkit,value=10}
M.pistol_ammo = {id=2,icon=hash("pistol_ammo"),scale=0.010625, position_z =-0.35,type=M.TYPES.ammo,weapon_id=2,value=2}
M.nailgun_ammo = {id=3,icon=hash("nailgun_ammo"),scale=0.015625, position_z =-0.4,type=M.TYPES.ammo,weapon_id=3,value=10}
M.ball = {id=4,icon=hash("ball"),scale=0.025, position_z =-0.2,type=M.TYPES.ball,value=10}

M.MAP = {
	[1]=M.medkit,
	[2]=M.pistol_ammo,
	[3]=M.nailgun_ammo,
    [4]=M.ball
}

return M
