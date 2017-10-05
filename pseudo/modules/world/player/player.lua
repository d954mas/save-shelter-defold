local constants = require("pseudo.modules.constants")
local PlayerMC = require("pseudo.modules.world.player.player_mc")
local player_weapon=require("pseudo.modules.world.player.player_weapon")

local M = {}

M.pos = vmath.vector3(2,2,0)
M.angle = constants.PLATER_START_ROT

-- Is the playing moving forward (speed = 1)
-- or backwards (speed = -1).
M.velocity = vmath.vector3(0)
M.speed = constants.PLAYER_SPEED

M.fix_world_quaterion = vmath.quat_rotation_x(1.57)

function M.get_rotation_quaterion()
	return M.fix_world_quaterion * vmath.quat_rotation_y(M.angle)
end	

M.controller=PlayerMC:new(M)
--begin observables
M.max_health = 100
M.health = 100
M.max_mana = 100
M.mana = 0
M.mana_regen = 20
M.weapons=player_weapon

function M.reset()
	M.controller:clear()
	--begin observables
	M.max_health = 100
	M.health = 100
	M.max_mana = 100
	M.mana = 0
	M.mana_regen = 20
	M.weapons=player_weapon
	player_weapon[2].weapon.ammo = 10
	M.pos = vmath.vector3(2,2,0)
	M.angle = constants.PLATER_START_ROT
end

function M.need_heal()
	return M.max_health>M.health
end

function M.need_ammo(weapon_id)
	local weapon=M.weapons[weapon_id].weapon
	return weapon.ammo<weapon.max_ammo
end

function M.get_current_weapon() 
	return M.weapons[M.weapons.current_weapon].weapon
end



--end observables
return M
