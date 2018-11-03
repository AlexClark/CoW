/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_tinker_ou
//
//  Desc:  This is the OnUsed handler for the
//         Tinker's Table.
//
//         This OnUsed handler is meant to fix a Bioware
//         bug that sometimes prevents placeables from
//         getting OnOpen or OnClose events. This OnUsed
//         handler in coordination with the OnDisturbed
//         ("cnr_device_od") handler work around the bug.
//
//  Author: David Bobeck 07Apr03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

/////////////////////////////////////////////////////////
void TestIfRecipesHaveBeenCollected(object oUser)
{
  int nStackCount = CnrGetStackCount(oUser);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenCollected(oUser));
  }
  else
  {
    SetLocalString(OBJECT_SELF, "dialog", "zz_co_crafting");
    ActionStartConversation(oUser, "zzdlg_conv", TRUE);
  }
}

/////////////////////////////////////////////////////////
void TestIfRecipesHaveBeenInitialized(object oUser)
{
  int nStackCount = CnrGetStackCount(oUser);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenInitialized(oUser));
  }
  else
  {
    // Note: A placeable will receive events in the following order...
    // OnOpen, OnUsed, OnDisturbed, OnClose, OnUsed.
    if (GetLocalInt(OBJECT_SELF, "bCnrDisturbed") != TRUE)
    {
      // Skip if the contents have not been altered.
      return;
    }

    SetLocalInt(OBJECT_SELF, "bCnrDisturbed", FALSE);

    // If the Bioware bug is in effect, simulate the closing
    if (GetIsOpen(OBJECT_SELF))
    {
      AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
    }

    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    if (oItem == OBJECT_INVALID)
    {
      // Skip if empty.
      return;
    }

    if (GetIsObjectValid(oUser) && GetIsPC(oUser))
    {
      // 5% of the time the player will get blown up!
      if (d20(1) == 20)
      {
        effect eBoom = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE, FALSE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBoom, GetLocation(OBJECT_SELF));
        effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE , FALSE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, GetLocation(OBJECT_SELF));

        // take 5% damage or 1, whichever is more
        int nDamage = FloatToInt(GetMaxHitPoints(oUser) * 0.05);
        if (nDamage == 0)
        {
          nDamage = 1;
        }
        effect eDamage = EffectDamage(nDamage);
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamage, oUser);
        DelayCommand(2.0, FloatingTextStringOnCreature(CNR_TEXT_YOU_NEED_TO_BE_MORE_CAREFUL, oUser, FALSE));
        return;
      }


      if (CnrRecipeDeviceToolsArePresent(oUser, OBJECT_SELF))
      {
        SetLocalInt(oUser, "nCnrMenuPage", 0);
        SetLocalString(oUser , "sCnrCurrentMenu", GetTag(OBJECT_SELF));

        // this call is asynchronous - it uses stack helpers to avoid TMI
        CnrCollectDeviceRecipes(oUser, OBJECT_SELF, TRUE);

        //ActionStartConversation(oUser, "", TRUE);

        // wait until collection is done before starting the conversation
        AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenCollected(oUser));
      }
    }
  }
}

/////////////////////////////////////////////////////////
void main()
{
  object oUser = GetLastUsedBy();
  if (!GetIsPC(oUser))
  {
    return;
  }

  // this call is asynchronous - it uses stack helpers to avoid TMI
  CnrInitializeDeviceRecipes(oUser, OBJECT_SELF);

  // wait until initialization is done before continuing
  AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenInitialized(oUser));
}