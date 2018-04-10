
//::///////////////////////////////////////////////////
//:: X0_TRAPAVG_STINK
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_STINKING_CLOUD
//:: Spell caster level: 5
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

#include "mi_inc_traps"
void main()
{
    TriggerProjectileTrap(SPELL_STINKING_CLOUD, GetEnteringObject(), 5);
}

