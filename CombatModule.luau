--!strict
local CombatModule = {}
CombatModule.__index = CombatModule

type CombatState = "Idle" | "Attacking" | "Stunned" | "Cooldown"

export type CombatInstance = typeof(setmetatable({} as {
	State: CombatState,
	Damage: number,
	CooldownTime: number,
	LastAttack: number,
}, CombatModule))

function CombatModule.new(damage: number, cooldown: number): CombatInstance
	local self = {
		State = "Idle" :: CombatState,
		Damage = damage,
		CooldownTime = cooldown,
		LastAttack = 0,
	}
	return setmetatable(self, CombatModule)
end

function CombatModule:TryAttack(player: Player): boolean
	if self.State ~= "Idle" then
		return false
	end
	
	local currentTime = os.clock()
	if currentTime - self.LastAttack < self.CooldownTime then
		return false
	end
	
	self.State = "Attacking"
	self.LastAttack = currentTime
	return true
end

function CombatModule:ResetState()
	self.State = "Idle"
end

return CombatModule
