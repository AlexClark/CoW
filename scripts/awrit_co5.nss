// awrit_co5
#include "gs_inc_token"
#include "inc_quest"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

	   if (oWrit == OBJECT_INVALID)
		      return;

	   SetLocalString(oWrit, "ExaminedContract", GetLocalString(oWrit, QUEST_ONE_IDENT));
}
