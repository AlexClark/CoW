
//::///////////////////////////////////////////////////
//:: X0_TRAPWK_ARROW
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_TRAP_ARROW
//:: Spell caster level: 1
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

#include "mi_inc_traps"
void main()
{
    TriggerProjectileTrap(SPELL_TRAP_ARROW, GetEnteringObject(), 1,
                          OBJECT_INVALID, OBJECT_SELF,
                          PROJECTILE_PATH_TYPE_HOMING);
}

