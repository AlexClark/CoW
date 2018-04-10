#include "fb_inc_chatutils"
#include "gs_inc_pc"
#include "inc_examine"

const string HELP = "DM command: Displays the Roleplay Ratings of every player currently online. Players with a Mark of Destiny have (Destiny) added to their name, players with a mark of despair have (Despair) added to their name.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-rp_ratings", HELP);
  }
  else
  {
    string sMessage = " PC name (player name): Current RP rating\n";
    int nRating;
    int nIsDM;
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
      if (!GetIsDM(oPC))
      {
        nIsDM = FALSE;
        nRating = gsPCGetRolePlay(oPC);
        switch (nRating)
        {
          case 0:
            sMessage += "  <c�  >";
            break;
          case 10:
            sMessage += "  <c� �>";
            break;
          case 20:
            sMessage += "  <c�+?>";
            break;
          case 30:
            sMessage += "  <c ��>";
            break;
          case 40:
            sMessage += "  <c � >";
            break;
          default:
            sMessage += "  <c���>";
            break;
        }

        sMessage += GetName(oPC) + " (" + GetPCPlayerName(oPC) + "): " +
                                                IntToString(nRating);

        if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_despair")))
        {
          sMessage += " <c�  >(Despair)</c>";
        }

        if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")))
        {
          sMessage += " <c � >(Destiny)</c>";
        }
      }
      else
      {
        nIsDM = TRUE;
      }

      oPC = GetNextPC();
      if (GetIsObjectValid(oPC) && !nIsDM) sMessage += "\n";
    }

    SendMessageToPC(oSpeaker, sMessage);
  }

  chatVerifyCommand(oSpeaker);
}
