/* ENCOUNTER library by Gigaschatten */

#include "gs_inc_area"
#include "gs_inc_flag"
#include "gs_inc_subrace"
#include "gu_inc_encounter"

//void main() {}

const float GS_EN_DISTANCE          = 25.0;
const int GS_EN_LIMIT_SLOT          = 15;
const int GS_EN_LIMIT_ENCOUNTER     = 25;
const int GS_EN_LIMIT_SPAWN         =  6;

//create encounter spawn positions in oArea
void gsENSetUpArea(object oArea = OBJECT_SELF);
//spawn creatures near oPC
void gsENSpawn(object oPC = OBJECT_SELF);
//spawn a maximum of nCount creatures by nChance at fDistance near lLocation depending on fChallenge and playing nEffect
void gsENSpawnAtLocation(float fChallenge, int nCount, location lLocation, float fDistance = 5.0, int nEffect = FALSE, float fBaseChallenge = 0.0f);
//internally used
object _gsENSpawnAtLocation(string sTemplate, location lLocation, int nEffect = FALSE);
//return player rating at lLocation within fRange
float gsENGetRatingAtLocation(location lLocation, float fRange = 40.0);
//return current encounter spawn limit of oArea
int gsENGetEncounterLimit(object oArea = OBJECT_SELF);
//return spawn location with fDistance to oPC
location gsENGetSpawnLocation(object oPC = OBJECT_SELF, float fDistance = 25.0);
//set encounter nChance of oArea
void gsENSetEncounterChance(int nChance, object oArea = OBJECT_SELF);
//return encounter chance of oArea
int gsENGetEncounterChance(object oArea = OBJECT_SELF);
//set minimum fRating of oArea
void gsENSetMinimumRating(float fRating, object oArea = OBJECT_SELF);
//return minimum rating of oArea
float gsENGetMinimumRating(object oArea = OBJECT_SELF);
//set oCreature for oArea with nChance of appearance
void gsENSetCreature(object oCreature, int nChance = 5, object oArea = OBJECT_SELF, int bNight = FALSE);
//set appearance nChance of creature in nSlot of oArea
void gsENSetCreatureChance(int nSlot, int nChance, object oArea = OBJECT_SELF, int bNight = FALSE);
//return name of creature in nSlot of oArea
string gsENGetCreatureName(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE);
//return template of creature in nSlot of oArea
string gsENGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE);
//return challenge rating of creature in nSlot of oArea
float gsENGetCreatureRating(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE);
//return appearance chance of creature in nSlot of oArea
int gsENGetCreatureChance(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE);
//remove creature in nSlot from oArea
void gsENRemoveCreature(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE);
//return TRUE if oCreature is an encounter
int gsENGetIsEncounterCreature(object oCreature = OBJECT_SELF);
//save settings of oArea
void gsENSaveArea(object oArea = OBJECT_SELF);
//load setting of oArea.  Set bOverride to FALSE to avoid loading from the
//database if we already have data.
void gsENLoadArea(object oArea = OBJECT_SELF, int bOverride = TRUE);
//copy setting of area oSource to area oTarget
void gsENCopyArea(object oSource, object oTarget = OBJECT_SELF);

void gsENSetUpArea(object oArea = OBJECT_SELF)
{
    float fSizeX  = gsARGetSizeX(oArea);
    float fSizeY  = gsARGetSizeY(oArea);
    float fX      = 0.0;
    float fY      = 0.0;
    int nSizeX    = FloatToInt(fSizeX) - 19;
    int nSizeY    = FloatToInt(fSizeY) - 19;
    int nCount    = FloatToInt(fSizeX * fSizeY *
                               IntToFloat(gsENGetEncounterChance(oArea)) /
                               (GS_EN_DISTANCE * GS_EN_DISTANCE * 100.0));
    int nNth      = 0;

    for (; nNth < nCount; nNth++)
    {
        fX = IntToFloat(10 + Random(nSizeX));
        fY = IntToFloat(10 + Random(nSizeY));

        guENTryDynamicEncounter(Location(oArea, Vector(fX, fY), 0.0),
                                GS_EN_DISTANCE);
    }
}
//----------------------------------------------------------------
void gsENSpawn(object oPC = OBJECT_SELF)
{
    object oArea = GetArea(oPC);
    int nChance  = gsENGetEncounterChance(GetArea(oPC));

    if (nChance > 0 &&
        nChance + Random(100) >= 100)
    {
        int nCount = gsENGetEncounterLimit(oArea);

        if (nCount > 0)
        {
            location lLocation = gsENGetSpawnLocation(oPC);
            float fRating1     = gsENGetRatingAtLocation(lLocation);
            float fRating2     = gsENGetMinimumRating(oArea);

            if (fRating1 < fRating2) fRating1 = fRating2;

            if (fRating1 > 0.0)
            {
                //spawn
                gsENSpawnAtLocation(fRating1, nCount, lLocation, 5.0, FALSE);
            }
        }
    }
}
//----------------------------------------------------------------
void gsENSpawnAtLocation(float fChallenge, int nCount, location lLocation, float fDistance = 5.0, int nEffect = FALSE, float fBaseChallenge = 0.0f)
{
    object oArea      = GetAreaFromLocation(lLocation);
    object oCreature  = OBJECT_INVALID;
    vector vPosition  = GetPositionFromLocation(lLocation);
    vector _vPosition;
    string sTemplate  = "";
    float fSizeX      = gsARGetSizeX(oArea) - 5.0;
    float fSizeY      = gsARGetSizeY(oArea) - 5.0;
    float _fChallenge = fChallenge * 1.5;
    float fRating     = 0.0;
    int _nChance      = 0;

    int _nCount       = 0;
    int nLimit        = 0;
    int nRandom       = 0;
    int nSlot         = 0;

    string sNth       = "";
    int nNth1         = 0;
    int nNth2         = 0;

    int bNight = GetIsNight();

    // If night time, check whether we have any night time encounters set up.
    // Otherwise, use day time encounters.
    if (bNight && gsENGetCreatureTemplate(1, oArea, TRUE) == "") bNight = FALSE;

    //preselection
    for (nNth1 = 1; nNth1 <= GS_EN_LIMIT_SLOT; nNth1++)
    {
        sTemplate = gsENGetCreatureTemplate(nNth1, oArea, bNight);
        fRating   = gsENGetCreatureRating(nNth1, oArea, bNight);
        _nChance  = gsENGetCreatureChance(nNth1, oArea, bNight);

        if (sTemplate != "" &&
            fRating > 0.0 &&
            _nChance > 0 &&
            (fRating <= fChallenge ||
             Random(100) == 99))
        {
            _nChance = fRating > fChallenge ?
                       FloatToInt(IntToFloat(_nChance) * _fChallenge / fRating) :
                       FloatToInt(IntToFloat(_nChance) * fRating * 1.5 / fChallenge);

            if (_nChance < 1)       _nChance =  1;
            else if (_nChance > 10) _nChance = 10;

            sNth    = IntToString(++_nCount);
            nLimit += _nChance;

            SetLocalInt(oArea, "GS_EN_SLOT_"  + sNth, nNth1);
            SetLocalInt(oArea, "GS_EN_LIMIT_" + sNth, nLimit);
        }
    }

    //spawn encounter
    fRating           = 0.0;
    nNth1             = 0;

    if (nCount > GS_EN_LIMIT_SPAWN) nCount = GS_EN_LIMIT_SPAWN;

    while (fRating < _fChallenge &&
           ++nNth1 <= nCount)
    {
        nRandom = Random(nLimit);

        for (nNth2 = 1; nNth2 <= _nCount; nNth2++)
        {
            sNth = IntToString(nNth2);

            if (nRandom < GetLocalInt(oArea, "GS_EN_LIMIT_" + sNth))
            {
                _vPosition  = vPosition + AngleToVector(IntToFloat(Random(360))) * fDistance;

                if (_vPosition.x > fSizeX)   _vPosition.x = fSizeX;
                else if (_vPosition.x < 5.0) _vPosition.x = 5.0;
                if (_vPosition.y > fSizeY)   _vPosition.y = fSizeY;
                else if (_vPosition.y < 5.0) _vPosition.y = 5.0;

                //spawn creature
                lLocation   = Location(oArea, _vPosition, 0.0);
                nSlot       = GetLocalInt(oArea, "GS_EN_SLOT_" + sNth);
                sTemplate   = gsENGetCreatureTemplate(nSlot, oArea, bNight);
                fRating    += gsENGetCreatureRating(nSlot, oArea, bNight);

                oCreature = _gsENSpawnAtLocation(sTemplate, lLocation, nEffect);
                break;
            }
        }
    }

    // Spawn loot item.  This is an item that will give a scaled amount of gold
    // to each member of a party once.
    // -- Removed and replaced by equivalent function on the standard Carcass
    // object.
    //if (GetIsObjectValid(oCreature) && GetIsReactionTypeHostile(GetFirstPC(), oCreature))
    //{
    //  object oTreasure = CreateObject(OBJECT_TYPE_PLACEABLE, "mi_en_tres", lLocation);
    //
    //  SetLocalFloat(oTreasure, "MI_EN_CR", fBaseChallenge);
    //}
}
//----------------------------------------------------------------
object _gsENSpawnAtLocation(string sTemplate, location lLocation, int nEffect = FALSE)
{
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lLocation);

    if (GetIsObjectValid(oCreature))
    {
        gsFLSetFlag(GS_FL_ENCOUNTER, oCreature);

        if (nEffect) ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                                           EffectVisualEffect(nEffect),
                                           GetLocation(oCreature));
    }

    return oCreature;
}
//----------------------------------------------------------------
float gsENGetRatingAtLocation(location lLocation, float fRange = 40.0)
{
    object oCreature    = OBJECT_INVALID;
    object oMaster      = OBJECT_INVALID;
    object oEquipment   = OBJECT_INVALID;
    float fRating       = 0.0;
    float fRatingTotal  = 0.0;
    int nSubRace        = GS_SU_NONE;
    int nEquipmentValue = 0;

    //compute rating
    oCreature           = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation);

    while (GetIsObjectValid(oCreature))
    {
        if (! GetIsDMPossessed(oCreature))
        {
            fRating       = 0.0;

            if (GetIsPC(oCreature))
            {
                nSubRace         = gsSUGetSubRaceByName(GetSubRace(oCreature));
                fRating          = IntToFloat(gsSUGetECL(nSubRace, GetHitDice(oCreature)));
                nEquipmentValue  = 0;

                oEquipment       = GetItemInSlot(INVENTORY_SLOT_ARMS,      oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_BELT,      oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_BOOTS,     oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_CHEST,     oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_CLOAK,     oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_HEAD,      oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_NECK,      oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);
                oEquipment       = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oCreature);
                if (GetIsObjectValid(oEquipment)) nEquipmentValue += GetGoldPieceValue(oEquipment);

                fRating         += IntToFloat(nEquipmentValue) / 10000.0;
            }
            else
            {
                oMaster          = GetMaster(oCreature);

                while (GetIsObjectValid(oMaster))
                {
                    if (GetIsPC(oMaster))
                    {
                        fRating = GetChallengeRating(oCreature);
                        break;
                    }

                    oMaster = GetMaster(oMaster);
                }
            }

            fRating      *= fRating;
            fRatingTotal += fRating;
        }

        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation);
    }

    return sqrt(fRatingTotal);
}
//----------------------------------------------------------------
int gsENGetEncounterLimit(object oArea = OBJECT_SELF)
{
    object oObject = GetFirstObjectInArea(oArea);
    int nCount     = 0;

    while (GetIsObjectValid(oObject))
    {
        if (gsENGetIsEncounterCreature(oObject)) nCount++;
        oObject = GetNextObjectInArea(oArea);
    }

    nCount         = FloatToInt(gsARGetSizeX(oArea) + gsARGetSizeY(oArea)) *
                                gsENGetEncounterChance(oArea) / 1000 -
                                nCount;

    if (nCount > GS_EN_LIMIT_ENCOUNTER) nCount = GS_EN_LIMIT_ENCOUNTER;
    else if (nCount < 0)                nCount = 0;

    return nCount;
}
//----------------------------------------------------------------
location gsENGetSpawnLocation(object oPC = OBJECT_SELF, float fDistance = 25.0)
{
    object oArea     = GetArea(oPC);
    object oCreature = OBJECT_INVALID;
    location lTarget1;
    location lTarget2;
    location lCreature;
    vector vSource   = GetPosition(oPC);
    vector vTarget;
    vector vCreature;
    float fSizeX     = gsARGetSizeX(oArea) - 5.0;
    float fSizeY     = gsARGetSizeY(oArea) - 5.0;
    float fStart     = IntToFloat(Random(360));
    float fEnd       = fStart + 360.0;
    float fDistance1 = 0.0;
    float fDistance2 = 0.0;

    vSource.z        = 0.0;

    while (fStart < fEnd)
    {
        vTarget      = vSource + AngleToVector(fStart) * fDistance;

        if (vTarget.x > fSizeX)   vTarget.x = fSizeX;
        else if (vTarget.x < 5.0) vTarget.x = 5.0;
        if (vTarget.y > fSizeY)   vTarget.y = fSizeY;
        else if (vTarget.y < 5.0) vTarget.y = 5.0;

        lTarget1     = Location(oArea, vTarget, 0.0);
        oCreature    = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lTarget1);
        vCreature    = GetPosition(oCreature);
        vCreature.z  = 0.0;
        lCreature    = Location(oArea, vCreature, 0.0);
        fDistance1   = GetDistanceBetweenLocations(lTarget1, lCreature);

        if (fDistance1 >= fDistance) return lTarget1;

        if (fDistance1 > fDistance2)
        {
            lTarget2   = lTarget2;
            fDistance2 = fDistance2;
        }

        fStart      += 45.0;
    }

    return lTarget2;
}
//----------------------------------------------------------------
void gsENSetEncounterChance(int nChance, object oArea = OBJECT_SELF)
{
    SetLocalInt(oArea, "GS_EN_CHANCE", nChance);
}
//----------------------------------------------------------------
int gsENGetEncounterChance(object oArea = OBJECT_SELF)
{
    return GetLocalInt(oArea, "GS_EN_CHANCE");
}
//----------------------------------------------------------------
void gsENSetMinimumRating(float fRating, object oArea = OBJECT_SELF)
{
    SetLocalFloat(oArea, "GS_EN_RATING", fRating);
}
//----------------------------------------------------------------
float gsENGetMinimumRating(object oArea = OBJECT_SELF)
{
    return GetLocalFloat(oArea, "GS_EN_RATING");
}
//----------------------------------------------------------------
void gsENSetCreature(object oCreature, int nChance = 5, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
    if (GetIsPC(oCreature))                               return;
    if (nChance < 0)                                      nChance =  0;
    else if (nChance > 10)                                nChance = 10;
    if (! GetIsObjectValid(oArea))                        oArea   = GetArea(oCreature);

    string sTemplate1 = GetResRef(oCreature);
    if (sTemplate1 == "")                                 return;
    string sTemplate2 = "";
    int nSlot         = FALSE;
    int nNth          = 0;

    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sTemplate2 = gsENGetCreatureTemplate(nNth, oArea, bNight);

        if (sTemplate1 == sTemplate2)
        {
            nSlot = nNth;
            break;
        }
        else if (! nSlot &&
                 sTemplate2 == "")
        {
            nSlot = nNth;
        }
    }

    if (nSlot)
    {
        string sNth = IntToString(nSlot);

        SetLocalString(oArea, "GS_EN_NAME_" + sNth + (bNight ? "N" : ""), GetName(oCreature, TRUE));
        SetLocalString(oArea, "GS_EN_RESREF_" + sNth + (bNight ? "N" : ""), sTemplate1);
        SetLocalFloat(oArea, "GS_EN_RATING_" + sNth + (bNight ? "N" : ""), GetChallengeRating(oCreature));
        SetLocalInt(oArea, "GS_EN_CHANCE_" + sNth + (bNight ? "N" : ""), nChance);
    }
}
//----------------------------------------------------------------
void gsENSetCreatureChance(int nSlot, int nChance, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    SetLocalInt(oArea, "GS_EN_CHANCE_" + IntToString(nSlot) + (bNight ? "N" : ""), nChance);
}
//----------------------------------------------------------------
string gsENGetCreatureName(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    return GetLocalString(oArea, "GS_EN_NAME_" + IntToString(nSlot) + (bNight ? "N" : ""));
}
//----------------------------------------------------------------
string gsENGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    return GetLocalString(oArea, "GS_EN_RESREF_" + IntToString(nSlot) + (bNight ? "N" : ""));
}
//----------------------------------------------------------------
float gsENGetCreatureRating(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    return GetLocalFloat(oArea, "GS_EN_RATING_" + IntToString(nSlot) + (bNight ? "N" : ""));
}
//----------------------------------------------------------------
int gsENGetCreatureChance(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    return GetLocalInt(oArea, "GS_EN_CHANCE_" + IntToString(nSlot) + (bNight ? "N" : ""));
}
//----------------------------------------------------------------
void gsENRemoveCreature(int nSlot, object oArea = OBJECT_SELF, int bNight = FALSE)
{
    string sNth = IntToString(nSlot);

    DeleteLocalString(oArea, "GS_EN_NAME_" + sNth + (bNight ? "N" : ""));
    DeleteLocalString(oArea, "GS_EN_RESREF_" + sNth + (bNight ? "N" : ""));
    DeleteLocalFloat(oArea, "GS_EN_RATING_" + sNth + (bNight ? "N" : ""));
    DeleteLocalInt(oArea, "GS_EN_CHANCE_" + sNth + (bNight ? "N" : ""));
}
//----------------------------------------------------------------
int gsENGetIsEncounterCreature(object oCreature = OBJECT_SELF)
{
    return GetObjectType(oCreature) == OBJECT_TYPE_CREATURE &&
           (GetIsEncounterCreature(oCreature) ||
            gsFLGetFlag(GS_FL_ENCOUNTER, oCreature));
}
//----------------------------------------------------------------
void gsENSaveArea(object oArea = OBJECT_SELF)
{

    string sNth      = "";
    int nNth         = 0;
    int iAreaID = gvd_GetAreaID(oArea);
    string sType;
    string sName;
    string sResRef;
    float fRating;
    int iChance;
    string sLocation;

    // Day encounters.
    sType = "Day";
    sLocation = "";

    // first delete all encounters from db (day and night) for this area
    SQLExecDirect("DELETE FROM gvd_encounter WHERE ((type = 'Day') OR (type = 'Night')) AND (area_id = " + IntToString(iAreaID) + ")");

    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(gsENGetCreatureName(nNth, oArea));
        sResRef = SQLEncodeSpecialChars(gsENGetCreatureTemplate(nNth, oArea));
        fRating = gsENGetCreatureRating(nNth, oArea);
        iChance = gsENGetCreatureChance(nNth, oArea);

        if (sResRef != "") { 
          SQLExecDirect("INSERT INTO gvd_encounter (area_id, type, resref, name, rating, chance, location) VALUES (" + IntToString(iAreaID) + ",'" + sType + "','" + sResRef + "','" + sName + "'," + FloatToString(fRating) + "," + IntToString(iChance) + ",'" + sLocation + "')");          
        }

    }

    // Night encounters.
    sType = "Night";
    sLocation = "";
    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(gsENGetCreatureName(nNth, oArea, TRUE));
        sResRef = SQLEncodeSpecialChars(gsENGetCreatureTemplate(nNth, oArea, TRUE));
        fRating = gsENGetCreatureRating(nNth, oArea, TRUE);
        iChance = gsENGetCreatureChance(nNth, oArea, TRUE);

        if (sResRef != "") { 
          SQLExecDirect("INSERT INTO gvd_encounter (area_id, type, resref, name, rating, chance, location) VALUES (" + IntToString(iAreaID) + ",'" + sType + "','" + sResRef + "','" + sName + "'," + FloatToString(fRating) + "," + IntToString(iChance) + ",'" + sLocation + "')");          
        }

    }

    gvd_SetAreaInt(oArea, "CHANCE", gsENGetEncounterChance(oArea));
    gvd_SetAreaFloat(oArea, "RATING", gsENGetMinimumRating(oArea));

}
//----------------------------------------------------------------
void gsENLoadArea(object oArea = OBJECT_SELF, int bOverride = TRUE)
{

    int iAreaID = gvd_GetAreaID(oArea);
    string sType;
    string sName;
    string sResRef;
    float fRating;
    int iChance;

    string sNth;
    int iDay = 1;
    int iNight = 1;

    if (!bOverride && gsENGetEncounterChance(oArea)) return;

    SQLExecDirect("SELECT type, resref, name, rating, chance FROM gvd_encounter WHERE (area_id = " + IntToString(iAreaID) + ") AND ((type = 'Day') OR (type = 'Night'))");

    while (SQLFetch()) {

      sType = SQLGetData(1);
      sResRef = SQLGetData(2);
      sName = SQLGetData(3);
      fRating = StringToFloat(SQLGetData(4));
      iChance = StringToInt(SQLGetData(5));

      if (sType == "Night") {

        sNth = IntToString(iNight);
        SetLocalString(oArea, "GS_EN_NAME_" + sNth + "N", sName);
        SetLocalString(oArea, "GS_EN_RESREF_" + sNth + "N", sResRef);
        SetLocalFloat(oArea, "GS_EN_RATING_" + sNth + "N", fRating);
        SetLocalInt(oArea, "GS_EN_CHANCE_" + sNth + "N", iChance);
        iNight = iNight + 1;

      } else {

        sNth = IntToString(iDay);
        SetLocalString(oArea, "GS_EN_NAME_" + sNth, sName);
        SetLocalString(oArea, "GS_EN_RESREF_" + sNth, sResRef);
        SetLocalFloat(oArea, "GS_EN_RATING_" + sNth, fRating);
        SetLocalInt(oArea, "GS_EN_CHANCE_" + sNth, iChance);
        iDay = iDay + 1;

      }

    }

    // since gsENLoadArea is executed after gvd_LoadAreaVars in gs_a_enter, we can safely grab the variables from the area itself here
    gsENSetEncounterChance(GetLocalInt(oArea, "CHANCE"), oArea);
    gsENSetMinimumRating(GetLocalFloat(oArea, "RATING"), oArea);
}
//----------------------------------------------------------------
void gsENCopyArea(object oSource, object oTarget = OBJECT_SELF)
{
    string sNth = "";
    int nNth    = 0;

    // Day encounters
    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        SetLocalString(oTarget,
                       "GS_EN_NAME_" + sNth,
                       GetLocalString(oSource, "GS_EN_NAME_" + sNth));
        SetLocalString(oTarget,
                       "GS_EN_RESREF_" + sNth,
                       GetLocalString(oSource, "GS_EN_RESREF_" + sNth));
        SetLocalFloat(oTarget,
                      "GS_EN_RATING_" + sNth,
                      GetLocalFloat(oSource, "GS_EN_RATING_" + sNth));
        SetLocalInt(oTarget,
                    "GS_EN_CHANCE_" + sNth,
                    GetLocalInt(oSource, "GS_EN_CHANCE_" + sNth));
    }

    // Night encounters
    for (nNth = 1; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        SetLocalString(oTarget,
                       "GS_EN_NAME_" + sNth + "N",
                       GetLocalString(oSource, "GS_EN_NAME_" + sNth + "N"));
        SetLocalString(oTarget,
                       "GS_EN_RESREF_" + sNth + "N",
                       GetLocalString(oSource, "GS_EN_RESREF_" + sNth + "N"));
        SetLocalFloat(oTarget,
                      "GS_EN_RATING_" + sNth + "N",
                      GetLocalFloat(oSource, "GS_EN_RATING_" + sNth + "N"));
        SetLocalInt(oTarget,
                    "GS_EN_CHANCE_" + sNth + "N",
                    GetLocalInt(oSource, "GS_EN_CHANCE_" + sNth + "N"));
    }

    gsENSetEncounterChance(gsENGetEncounterChance(oSource), oTarget);
    gsENSetMinimumRating(gsENGetMinimumRating(oSource), oTarget);
}
