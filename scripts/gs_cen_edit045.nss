#include "inc_encounter"

void main()
{
    int bNight = GetLocalInt(GetPCSpeaker(), "NIGHT");
    gsENSetCreatureChance(GetLocalInt(OBJECT_SELF, "GS_EN_SLOT"), 9, GetArea(OBJECT_SELF), bNight);
}
