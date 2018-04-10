
//::///////////////////////////////////////////////////
//:: X0_TRAPDLY_CKILL
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_CLOUDKILL
//:: Spell caster level: 13
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

#include "mi_inc_traps"
void main()
{
    TriggerProjectileTrap(SPELL_CLOUDKILL, GetEnteringObject(), 13);
}

