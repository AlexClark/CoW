#include "gs_inc_quarter"
#include "zdlg_include_i"
#include "gvd_inc_contain"
#include "mi_inc_factions"

void main()
{
    object oPC = GetClickingObject();
    object oQuarter = OBJECT_SELF;
    int nOwner = gsQUGetIsOwner(oQuarter, oPC);
	int nLockIfVacant = GetLocalInt(oQuarter, "QU_LOCK_IF_VACANT");

    int nOverrideSubrace = GetLocalInt(oQuarter, "GS_OVERRIDE_SUBRACE");

    if (gsQUGetIsPublic(oQuarter) ||
        nOwner ||
        (nOverrideSubrace && nOverrideSubrace == gsSUGetSubRaceByName(GetSubRace(oPC))) ||
        (! nOwner && gsQUGetIsAvailable(oQuarter) && !nLockIfVacant) ||
        GetIsDM(oPC) ||
        gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter)) ||
        md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2"))
    {
      if (nOwner)
      {
        gsQUTouchWithNotification(oQuarter, oPC);
      }

      gsQUOpen(oQuarter, oPC);
    }
    else
    {
      SetLocalString(oQuarter, VAR_SCRIPT, "zdlg_quarter_doo");
      StartDlg(oPC, oQuarter, "zdlg_quarter_doo", TRUE, FALSE);
    }
}
