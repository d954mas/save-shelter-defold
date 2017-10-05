local BaseMC = require("lib.controllers.base_mc")
local PlayerMC = BaseMC:subclass('PlayerMC')
local lume = require("lib.lume")
local weapons = require("pseudo.modules.models.weapons")

function PlayerMC:initialize(model)
	local events={
		HEALTH_CHANGED=hash("player_health_changed"),
		MAX_HEALTH_CHANGED=hash("player_max_health_changed"),
		MANA_CHANGED=hash("player_mana_changed"),
		MAX_MANA_CHANGED=hash("player_max_mana_changed"),
		AMMO_CHANGED=hash("player_ammo_changed"),
		WEAPON_CHANGED=hash("player_weapon_changed"),
	}
	BaseMC.initialize(self,model,events)
end

function PlayerMC:change_health(value)
	self.model.health = lume.clamp(self.model.health+value,0,self.model.max_health)
	self:notify(self.events.HEALTH_CHANGED)
end

function PlayerMC:change_mana(value)
	if(self.model.mana~=self.model.max_mana) then
		self.model.mana = lume.clamp(self.model.mana+value,0,self.model.max_mana)
		self:notify(self.events.MANA_CHANGED)
	end	
end

function PlayerMC:pickup_weapon(weapon_id)
	local weapon=self.model.weapons[weapon_id]
	weapon.existed=true
	self:change_ammo(weapon_id,10)
end

function PlayerMC:change_weapon(value)
	local id=self.model.weapons.current_weapon
	while(true) do
		id = id + value
		if(id<1 or id>2) then return end
		if(self.model.weapons[id].existed) then
			self.model.weapons.current_weapon=id
			self:notify(self.events.WEAPON_CHANGED)
			self:notify(self.events.AMMO_CHANGED)
			return
		end	
	end
end

function PlayerMC:make_shot()
	local weapon = self.model.get_current_weapon()
	weapon.ammo=weapon.ammo - 1
	self:notify(self.events.AMMO_CHANGED)
end

function PlayerMC:change_ammo(weapon_id,value)
	local weapon = self.model.weapons[weapon_id].weapon
	weapon.ammo=lume.clamp(weapon.ammo+value,0,weapon.max_ammo)
	self:notify(self.events.AMMO_CHANGED)
end	



return PlayerMC