//::///////////////////////////////////////////////
//:: Dirge: On Exit
//:: x0_s0_dirgeET.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    MARCH 2003
    Remove the negative effects of the dirge.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//:: Update Pass By: ActionReplay


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "mi_inc_spells"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    /*
    object oTarget = GetExitingObject();
    effect eAOE;
    int bValid = FALSE;

    //SpawnScriptDebugger();
    if(GetHasSpellEffect(SPELL_DIRGE, oTarget))
    {
        //DeleteLocalInt(oTarget, "X0_L_LASTPENALTY");

        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);

        while (GetIsEffectValid(eAOE) )
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the Dirge spell then remove it
                //::  Just skip removing the effect OnExit, Dirge is not a Temporary effect
                if(GetEffectSpellId(eAOE) == SPELL_DIRGE)
                {
                    //RemoveEffect(oTarget, eAOE);
                    //bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    */
}



