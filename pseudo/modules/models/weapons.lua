local M = {}
local sounds=require("pseudo.modules.models.sounds")

M.knife = {texture=hash("knife_1"),icon=nil,attack=hash("knife_attack"),type=hash("melee"),fire_rate=1,attack_img=4,}

M.knife = {
	id=1,
	ammo=1005000,
	max_ammo=1005000,
	idle=hash("knife_1"),
	ammo_icon=nil,
	attack=hash("knife_attack"),
	type=hash("melee"),
	proj_wait=7.5 * 1*0.01666,
	icon=nil,
	attack_sound=sounds.knife_shot
}
M.pistol = {
	id=2,
	ammo=10,
	max_ammo=100,
	idle=hash("pistol_1"),
	ammo_icon=hash("pistol_ammo"),
	attack=hash("pistol_attack"),
	type=hash("shoot"),
	proj_wait=7.5 * 1*0.01666,
	icon=hash("pistol_icon"),
	attack_sound=sounds.pistol_shot
}


	
M.nailgun = {
	id=3,
	ammo=0,
	max_ammo=100,
	idle=hash("nailgun_1"),
	ammo_icon=hash("nailgun_ammo"),
	attack=hash("nailgun_attack"),
	type=hash("shoot"),
	proj_wait=7.5 * 1*0.01666,
	icon=hash("nailgun_icon"),
	attack_sound=sounds.nailgun_shot}	




M.blaster = {texture=hash("blaster_1"),icon=hash("blaster_icon"),attack=hash("blaster_attack"),type=hash("shoot")}
M.rapid_blaster = {texture=hash("rapid_blaster_1"),icon=hash("rapid_blaster_icon"),attack=hash("rapid_blaster_attack"),type=hash("shoot")}
M.rocket_launcher = {texture=hash("rocket_1"),icon=hash("rocket_icon"),attack=hash("rocket_attack"),type=hash("shoot")}

return M
