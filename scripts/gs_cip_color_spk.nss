#include "inc_listener"
#include "inc_common"
void main()
{
    //slot 1

    object oPC   = GetPCSpeaker();
    object oItem = OBJECT_INVALID;
    object oCopy = OBJECT_INVALID;
    int nID      = GetLocalInt(OBJECT_SELF, "GS_ID");
    int nValue   = StringToInt(gsLIGetLastMessage(oPC));

    if (nValue == -1) return;

    //helmet
    oItem        = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);

    if (GetIsObjectValid(oItem))
    {
        oCopy = gsCMCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nID, nValue, TRUE);

        if (GetIsObjectValid(oCopy))
        {
            AssignCommand(oPC, ActionEquipItem(oCopy, INVENTORY_SLOT_HEAD));
            DestroyObject(oItem);
        }
    }

    //armor
    oItem        = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    if (GetIsObjectValid(oItem))
    {
        oCopy = gsCMCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nID, nValue, TRUE);

        if (GetIsObjectValid(oCopy))
        {
            AssignCommand(oPC, ActionEquipItem(oCopy, INVENTORY_SLOT_CHEST));
            DestroyObject(oItem);
        }
    }

    //cloak
    oItem        = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

    if (GetIsObjectValid(oItem))
    {
        oCopy = gsCMCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nID, nValue, TRUE);

        if (GetIsObjectValid(oCopy))
        {
            AssignCommand(oPC, ActionEquipItem(oCopy, INVENTORY_SLOT_CLOAK));
            DestroyObject(oItem);
        }
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL),
                        oPC,
                        0.25);
}

