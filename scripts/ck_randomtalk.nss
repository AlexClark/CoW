//::///////////////////////////////////////////////
//:: FileName a13_randomtalk
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 7/26/2003 6:59:12 PM
//:://////////////////////////////////////////////
int StartingConditional()
{
    if (!GetIsObjectValid(GetPCSpeaker())) return FALSE;
    // Add the randomness
    if(Random(10) >= 1)
        return FALSE;

    return TRUE;
}
