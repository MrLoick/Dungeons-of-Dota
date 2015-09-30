if tusk_slash == nil then
	tusk_slash = class({})
end

function tusk_slash:StopSwingGesture()
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
		self.nCurrentGesture = nil
	end
end

function tusk_slash:StartSwingGesture( nAction )
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
	end
	self.nCurrentGesture = nAction
	self:GetCaster():StartGesture( nAction )
	EmitSoundOn( "Hero_Tusk.Preattack", self:GetCaster() )
end

function tusk_slash:OnAbilityPhaseStart()
	local result = self.BaseClass.OnAbilityPhaseStart( self )
	if result then
		self:StartSwingGesture( ACT_DOTA_ATTACK )
	end
	return result
end

function tusk_slash:OnAbilityPhaseInterrupted()
	self:StopSwingGesture()
end

function tusk_slash:OnSpellStart()
	local nDamageAmount = self:GetCaster():GetAverageTrueAttackDamage() + self:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
	ApplyDamage( {
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = nDamageAmount,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self
	} )
	EmitSoundOn( "Hero_Tusk.Attack", self:GetCaster() )
end

function tusk_slash:GetCastRange( vLocation, hTarget )
	return 128
end
