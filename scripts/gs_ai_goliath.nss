#include "gs_inc_event"

void main()
{
    object oObject = OBJECT_INVALID;
    object oTarget = OBJECT_INVALID;

    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................

        break;

    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
    {
      int nRandomSpawn = d10(1);
      location lGoliathLocation = GetLocation(OBJECT_SELF);

      if(nRandomSpawn == 1)
      {
        CreateObject(OBJECT_TYPE_CREATURE, "risenundead1", lGoliathLocation, TRUE);
      }

      ExecuteScript("gs_run_ai", OBJECT_SELF);

      break;
    }
    case GS_EV_ON_PERCEPTION:
//................................................................

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................


    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;

    }
}
