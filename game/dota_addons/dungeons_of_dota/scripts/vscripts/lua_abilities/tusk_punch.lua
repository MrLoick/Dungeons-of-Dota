if tusk_punch == nil then
	tusk_punch = class({})
end

function tusk_punch:StopSwingGesture()
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
		self.nCurrentGesture = nil
	end
end

function tusk_punch:StartSwingGesture( nAction )
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
	end
	self.nCurrentGesture = nAction
	self:GetCaster():StartGesture( nAction )
end

function tusk_punch:OnAbilityPhaseStart()
	local result = self.BaseClass.OnAbilityPhaseStart( self )
	if result then
		self:StartSwingGesture( ACT_DOTA_ATTACK )
	end
	return result
end

function tusk_punch:OnAbilityPhaseInterrupted()
	self:StopSwingGesture()
end

function tusk_punch:OnSpellStart()
	print("Punch Spell Start")
	local nDamageAmount = self:GetCaster():GetAverageTrueAttackDamage() + self:GetAbilityDamage()
	print("Passed nDamageAmount")
	ApplyDamage( {
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = nDamageAmount,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self
	} )
	print("Damage applied")
end

function tusk_punch:GetCastRange( vLocation, hTarget )
	return 128
end
