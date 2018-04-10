#include "gs_inc_iprop"

int StartingConditional()
{
    int nTableID      = gsIPGetTableID("itempropdef");
    int nProperty     = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
    int nParamTableID = gsIPGetValue(nTableID, nProperty, "PARREF");
    int nID           = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4");
    int nCount        = gsIPGetCount(nParamTableID);

    return nID + 5 < nCount;
}
