#include "inc_token"

int StartingConditional()
{
    //slot 4

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_4") != -1)
    {
        gsTKRecallToken(103);
        return TRUE;
    }

    return FALSE;
}
