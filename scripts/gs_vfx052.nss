const string GS_TEMPLATE_OBJECT = "gs_null";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_OBJECT,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject))
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_INFERNO_CHEST)),
                            oObject);

    DestroyObject(OBJECT_SELF);
}
