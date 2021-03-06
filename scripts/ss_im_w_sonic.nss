/*
  Spellsword Imbue Weapon Ability - SONIC
*/

#include "inc_spellsword"

void main()
{
    int bFeedback = FALSE;

    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oSpellOrigin);

    if(bFeedback) SendMessageToPC(oSpellOrigin, "SS_IM_W entered");

    //make save
    int nSaveDC = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_DC_SONIC");
    int nSpellGroup = 1 + (nSaveDC - (10 + nWizard))/2;
	int nTimer = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_TM_SONIC") + 2;

    if ((!FortitudeSave(oSpellTarget, nSaveDC, SAVING_THROW_TYPE_SONIC)) && (gsTIGetActualTimestamp() > nTimer))
    {
		SetLocalInt(oSpellOrigin, "SS_IM_W_TM_SONIC", gsTIGetActualTimestamp());
		//remove previous effect
		effect eEffect = GetFirstEffect(oSpellTarget);
		while (GetIsEffectValid(eEffect))
		{
            if (GetIsTaggedEffect(eEffect, EFFECT_TAG_SPELLSWORD) && GetEffectType(eEffect) == EFFECT_TYPE_SILENCE)
			// if (GetEffectType(eEffect) == EFFECT_TYPE_REGENERATE) // use if NWNX not installed
			{
				RemoveEffect(oSpellTarget, eEffect);
			}

			eEffect = GetNextEffect(oSpellTarget);
		}
		
		//add new effect

		effect eImbueEffect = EffectSilence();
        float nDuration = 6.0 * nSpellGroup;
        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eImbueEffect), oSpellTarget, nDuration, EFFECT_TAG_SPELLSWORD);
    }
    return;
}
