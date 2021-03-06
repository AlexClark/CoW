#include "inc_chatutils"
#include "inc_external"
#include "inc_zombie"
#include "inc_common"
#include "inc_pc"
#include "inc_portal"
#include "inc_text"
#include "inc_xfer"
void main()
{
    object oExiting = GetExitingObject();

    // Added by Mithreas - unregister from listener and database. --[
    chatLeave(oExiting);
    miXFUnregisterPlayer(oExiting);
    // ]-- end edit
    if (GetIsDM(oExiting)) return;

    if (fbZGetIsZombie(oExiting))
    {
      SetCreatureAppearanceType(oExiting, fbZGetNaturalAppearance(oExiting));
    }

    //drop corpses if not portalling
    if (GetLocalString(gsPCGetCreatureHide(oExiting), "DEST_WP") == "")
    {
        gsPODropAllCorpses(oExiting);
    }
    else
    {
      object oCorpse = GetFirstItemInInventory(oExiting);

      while (GetIsObjectValid(oCorpse))
      {
        if ((GetResRef(oCorpse) == GS_TEMPLATE_CORPSE_FEMALE) ||
            (GetResRef(oCorpse) == GS_TEMPLATE_CORPSE_MALE))
        {
          object oTarget = gsPCGetPlayerByID(GetLocalString(oCorpse, "GS_TARGET"));

          if (GetIsObjectValid(oTarget))
          {
            string sServer = GetLocalString(oExiting, "TARGET_SERVER");
            SendMessageToPC(oTarget, "Your corpse has been moved to the " +
             miXFGetServerName(sServer) + " server.");
          }

          // Added By Space Pirate
          SetLocalInt(oCorpse, "SP_PORTALING", TRUE);
        }

        oCorpse = GetNextItemInInventory(oExiting);
      }
    }

    //store health
    SetLocalInt(gsCMGetCacheItem("HEALTH"),
                "GS_HEALTH_" + ObjectToString(oExiting),
                GetCurrentHitPoints(oExiting));

    fbEXFlush(oExiting);
}
