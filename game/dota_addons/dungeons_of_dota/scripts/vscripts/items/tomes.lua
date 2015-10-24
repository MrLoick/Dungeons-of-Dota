function StrengthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_strenght_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_strenght_modifier", nil)
        picker:SetModifierStackCount("tome_strenght_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_strenght_modifier", picker, (picker:GetModifierStackCount("tome_strenght_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 
    
    PopupStrTome(picker, statBonus)
end

function AgilityTomeUsed( event )
    
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseAgility( casterUnit:GetBaseAgility() + 1 )
    --casterUnit:ModifyAgility(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_agility_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_agility_modifier", nil)
        picker:SetModifierStackCount("tome_agility_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_agility_modifier", picker, (picker:GetModifierStackCount("tome_agility_modifier", picker) + statBonus))
    end

    PopupAgiTome(picker, statBonus)
end

function IntellectTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseIntellect( casterUnit:GetBaseIntellect() + 1 )
    --casterUnit:ModifyIntellect(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_intelect_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_intelect_modifier", nil)
        picker:SetModifierStackCount("tome_intelect_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_intelect_modifier", picker, (picker:GetModifierStackCount("tome_intelect_modifier", picker) + statBonus))
    end

    PopupIntTome(picker, statBonus)
end
