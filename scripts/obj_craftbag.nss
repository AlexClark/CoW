/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (OBJ) by Festyx
//
//  Name:  obj_craftbag
//
//  Desc:  This is a custom handler for crafting bag containers
//         ObjectTag based activation logic.
//         Handles loading object tags that can be stored in the bag,
//         and storing and removing said items.
//
//  Author: Alex Clark 13APR20
//
/////////////////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"

const int OBJ_INT_MAX = 2147483647;
const int OBJ_MAX_ITEM_QUANTITY = 9999;
const int OBJ_MAX_ITEM_QUANTITY_LENGTH = 4;

const string OBJ_CRAFTBAG_PREFIX = "OBJ_BAG_";
const int OBJ_CRAFTBAG_PREFIX_LENGTH = 8;

const string OBJ_CRAFTBAG_LIST_PREFIX = "OBJ_BAG_LIST_";
const int OBJ_CRAFTBAG_LIST_PREFIX_LENGTH = 13;

const string OBJ_CRAFTBAG_ENTRY_PREFIX = "BAGITM";
const int OBJ_CRAFTBAG_ENTRY_PREFIX_LENGTH = 6;
const string OBJ_CRAFTBAG_ENTRY_DIVIDER = "||";
const int OBJ_CRAFTBAG_ENTRY_DIVIDER_LENGTH = 2;

const string OBJ_CRAFTBAG_MAX_ITEM_KEY = "OBJ_BAG_MAXITEMS";
const string OBJ_CRAFTBAG_BASE_WEIGHT_KEY = "OBJ_BAG_BASE_WEIGHT";
const string OBJ_CRAFTBAG_WEIGHT_MULT_KEY = "OBJ_BAG_WEIGHT_MULTIPLIER";
const string OBJ_CRAFTBAG_CURRENT_WEIGHT_KEY = "OBJ_BAG_CURRENT_WEIGHT";

//Struct declarations for bag entries/keys
struct ObjBagKey
{
    string ResRef;
    string Tag;
    string Name;
};

struct ObjBagEntry
{
    int Count;
    string ResRef;
    string Tag;
    string Name;
    string Description;
};

// retrieves list of allowable items to be stored in a bag type
string ObjBagGetBagList(object mod, string type)
{
    GetLocalString(mod, OBJ_CRAFTBAG_LIST_PREFIX + type);
}

// sets list of allowable items to be stored in a bag type
void ObjBagInitList(object mod, string type, string list)
{
    SetLocalString(mod, OBJ_CRAFTBAG_LIST_PREFIX + type, list);
}

// Initialize module data store of valid items for craft bags
void ObjBagInit()
{
    object mod = GetModule();

    ObjBagInitList(mod, "HERB", 
          "cnrangelicaleaf,cnrwalnutfruit,cnraloeleaf,cnrgarlicclove,cnrcloverleaf,cnrsageleaf,"
        + "cnrpepmintleaf,cnrbirchbark,cnralmondfruit,cnrginsengroot,cnrgingerroot,cnrcomfreyroot,cnrhawthornfwr,"
        + "cnrcatnipleaf,cnrhazelleaf,cnrcalendulafwr,cnrchestnutfruit,cnrpecanfruit,cnrnettleleaf,"
        + "cnrskullcapleaf,cnrthistleleaf,cnrechinacearoot,cnrchamomilefwr");

    OBJInitList(mod, "GEMS",
        "");

}

// returns the count of items when provided the value text from an item entry
int ObjBagGetCountFromBagEntryText(string entry)
{
    return StringToInt(GetStringLeft(entry, OBJ_MAX_ITEM_QUANTITY_LENGTH));
}

//Parse an item key
struct ObjBagKey ObjBagParseBagItemKey(string key)
{
    struct ObjBagKey entry;

    int parseloc = OBJ_CRAFTBAG_ENTRY_PREFIX_LENGTH;
    int div = FindSubString(key, OBJ_CRAFTBAG_ENTRY_DIVIDER, parseloc);

    entry.ResRef = GetSubString(key, parseloc, div - parseloc);

    parseloc = div + OBJ_CRAFTBAG_ENTRY_DIVIDER_LENGTH;
    div = FindSubString(key, OBJ_CRAFTBAG_ENTRY_DIVIDER, parseloc);

    entry.Tag = GetSubString(key, parseloc, div - parseloc);

    parseloc = div + OBJ_CRAFTBAG_ENTRY_DIVIDER_LENGTH;

    entry.Name = GetSubString(key, parseloc, OBJ_INT_MAX);

    return entry;
}

// Parses a key/value pair for a bag item entry, and returns the entry struct
struct ObjBagEntry ObjBagParseBagEntry(string key, string entrytext)
{
    struct ObjBagEntry entry;
    struct ObjBagKey itemkey;

    itemkey = ObjBagParseBagItemKey(key);

    entry.ResRef = itemkey.ResRef;
    entry.Tag = itemkey.Tag
    entry.Name = itemkey.Name;

    if(entrytext != "")
    {
        entry.Count = ObjBagGetCountFromBagEntryText(entrytext);
        entry.Description = GetSubString(entrytext, OBJ_MAX_ITEM_QUANTITY_LENGTH, OBJ_INT_MAX);
    }
    else
    {
        entry.Count = 0;
        entry.Description = "";
    }

    return entry;
}

// serializes the string value for an entry
string ObjBagSerializeBagEntryText(struct ObjBagEntry entry)
{
    return IntToString(entry.Count) + entry.Description;
}

// checks if a key is an item entry key, returns true if it is, false otherwise
int ObjBagIsBagEntryKey(string key)
{
    iskey = FALSE;

    string prefix = GetSubString(key, 0, OBJ_CRAFTBAG_ENTRY_PREFIX_LENGTH);

    if(prefix == OBJ_CRAFTBAG_ENTRY_PREFIX)
    {
        iskey = TRUE;
    }

    return iskey;
}

// generates the key for an entry
string ObjBagGenerateBagEntryKey(struct ObjBagEntry entry)
{
    return OBJ_CRAFTBAG_ENTRY_PREFIX + entry.ResRef + OBJ_CRAFTBAG_ENTRY_DIVIDER + entry.Tag + OBJ_CRAFTBAG_ENTRY_DIVIDER + entry.Name;
}

// generates the key the given item would use for a bag entry
string ObjBagGenBagEntryKeyForItem(object item)
{
    return OBJ_CRAFTBAG_ENTRY_PREFIX + GetResRef(item) + OBJ_CRAFTBAG_ENTRY_DIVIDER + GetTag(item) + OBJ_CRAFTBAG_ENTRY_DIVIDER + GetName(item);
}

void ObjBagSetBagEntry(object bag, struct ObjBagEntry entry)
{
    string key = ObjBagGenerateBagEntryKey(entry);
    string text = ObjBagSerializeBagEntryText(entry);
    SetLocalString(bag, key, text);
}

// parses the given tag for the bag, and checks the item tag provided to see if it is a valid item type for the bag
int ObjBagIsValidTagForBag(string bag, string item)
{
    string type = GetStringUpperCase(GetSubString(bag, OBJ_CRAFTBAG_PREFIX_LENGTH, OBJ_INT_MAX));

    if(type == "")
    {
        return FALSE; // something went wrong, this is not a bag
    }

    string list = ObjBagGetBagList(GetModule(), type);
    int index = FindSubString(list, item);
    if(index == -1) {return FALSE;}
    return TRUE;
}

// checks if the given item can be stored in the given bag. does not check if the bag item is a bag.
int ObjBagIsValidItemForBag(object bag, object item)
{
    int ret = ObjBagIsValidTagForBag(GetTag(bag), GetTag(item));
    if(ret == TRUE && GetDroppableFlag(target) == TRUE && GetItemCursedFlag(target) == FALSE) {return TRUE;}
    return FALSE;
}

//returns true if the item is a craftbag, false otherwise
int ObjBagItemIsCraftBag(object item)
{
    string bagtag = GetTag(item);
    if(GetStringLeft(bagtag, OBJ_CRAFTBAG_PREFIX_LENGTH) != OBJ_CRAFTBAG_PREFIX)
    {
        return FALSE; // This isn't a crafting bag, nothing to do here
    }
    return TRUE;
}

// Sets the max item count for the entire bag
void ObjBagSetMaxItemsForBag(object bag, int max)
{
    SetLocalInt(bag, OBJ_CRAFTBAG_MAX_ITEM_KEY, max);
}

// gets the max item count the bag allows for all contained items
int ObjBagGetMaxItemsForBag(object bag)
{
    return GetLocalInt(bag, OBJ_CRAFTBAG_MAX_ITEM_KEY);
}

// gets the stored value for what the current bag weight should be
float ObjBagGetCurrentBagWeight(object bag)
{
    return GetLocalInt(bag, OBJ_CRAFTBAG_CURRENT_WEIGHT_KEY);
}

// Stored as a float, so that small, < 0.1 weight additions are not lost
void ObjBagSetCurrentBagWeight(object bag, float weight)
{
    SetLocalFloat(bag, OBJ_CRAFTBAG_CURRENT_WEIGHT_KEY, weight);
}

// Gets the bag's weight multiplier. 0.5 would halve all added weight.
float ObjBagGetBagWeightMultiplier(object bag)
{
    return GetLocalFloat(bag, OBJ_CRAFTBAG_WEIGHT_MULT_KEY);
}

// Sets the bag's weight multiplier. 0.5 would halve all added weight.
void ObjBagSetBagWeightMultiplier(object bag, float weight)
{
    SetLocalFloat(bag, OBJ_CRAFTBAG_WEIGHT_MULT_KEY, weight);
}

// returns total count of all items in the bag
int ObjBagGetCurrentItemsCountInBag(object bag)
{
    int count = 0;

    int vars = NWNX_Object_GetLocalVariableCount(bag);

    string key;
    int i;
    for(i = 0; i < vars; i++)
    {
        key = NWNX_Object_GetLocalVariable(bag, i);

        if(ObjBagIsBagEntryKey(key) == FALSE)
        {
            continue;
        }

        string entrytext = GetLocalString(bag, key);

        count = count + ObjBagGetCountFromBagEntryText(entrytext);
    }

    return count;
}

// returns the count of items currently in the bag for a given item
int ObjBagItemCountInBag(object bag, object item)
{
    int count = 0;

    string itemkey = ObjBagGenBagEntryKeyForItem(item);

    string entrytext = GetLocalString(bag, itemkey);

    if(entrytext != "")
    {
        count = ObjBagGetCountFromBagEntryText(entrytext);
    }

    return count;
}

void ObjBagStripWeightProperties(object bag)
{
    itemproperty prop = GetFirstItemProperty(bag);
    while (GetIsItemPropertyValid(prop)) 
    {
        if (GetItemPropertyType(prop) == ITEM_PROPERTY_WEIGHT_INCREASE) 
        {
            RemoveItemProperty(bag, prop);
        } 
        prop = GetNextItemProperty(bag);
    }
}

void ObjBagAddWeightProperties(object bag)
{
    float ratio = ObjBagGetBagWeightMultiplier(bag);
    float weight = ObjBagGetCurrentBagWeight(bag);
    int newWeight = FloatToInt(weight * ratio);

    int baseweight = GetWeight(bag);
    int remaining = newWeight - baseweight;

    while (remaining >= 1000) 
    {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), bag);
      remaining = remaining - 1000;
    }

    while (remaining >= 500) 
    {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS), bag);
      remaining = remaining - 500;
    }

    while (remaining >= 300) 
    {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_30_LBS), bag);
      remaining = remaining - 300;
    }

    while (remaining >= 150) 
    {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_15_LBS), bag);
      remaining = remaining - 150;
    }

    while (remaining >= 100) 
    {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_10_LBS), bag);
      remaining = remaining - 100;
    }

    while (remaining >= 50) 
    {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_5_LBS), bag);
      remaining = remaining - 50;
    }
}

// checks the current weight of the bag and sets the actual weight to within 5 lbs of the target weight based on the weight multiplier of the bag.
void ObjBagUpdateRealWeight(object bag)
{
    // clear all weight modifiers
    ObjBagStripWeightProperties(bag);

    //Delay adding properties as stripping old properties is not done until script completion
    DelayCommand(0.1, ObjBagAddWeightProperties(bag));
}

// util function to both set the current weight variable and update the real weight with it
void ObjBagSetAndUpdateCurrentWeight(object bag, float weight)
{
    ObjBagSetCurrentBagWeight(bag, weight);
    ObjBagUpdateRealWeight(bag);
}

struct ObjBagEntry ObjBagGetEntryForItem(object bag, object item)
{
    string key = ObjBagGenBagEntryKeyForItem(item);
    string text = GetLocalString(bag, key);
    return ObjBagParseBagEntry(key, text);
}

// Adds the item to the bag, returns amount of the stack added to the bag, or 0 for failure
// Does not check for validity, you should check first with ObjBagIsValidItemForBag()
int ObjBagAddItemToBag(object bag, object item)
{
    int added = 0;

    int currentcount = ObjBagGetCurrentItemsCountInBag(bag);
    int maxitems = ObjBagGetMaxItemsForBag(bag);

    if(currentcount >= maxitems)
    {
        return added; // we can't add the item
    }
    
    int currentitemcount = ObjBagItemCountInBag(bag, item);
    int stacksize = GetItemStackSize(item);
    int amountToAdd = stacksize;

    if(currentcount + stacksize > maxitems)
    {
        amountToAdd = maxitems - currentcount;
    }

    int newStackSize = stacksize - amountToAdd;
    int itemweight = GetWeight(item);
    float weightperitem = IntToFloat(itemweight) / IntToFloat(stacksize);
    float currentBagWeight = ObjBagGetCurrentBagWeight(bag);
    float newWeight = currentBagWeight + (amountToAdd * weightperitem);

    struct ObjBagEntry entry = ObjBagGetEntryForItem(bag, item);

    entry.Count = entry.Count + amountToAdd;

    if(entry.Description == "")
    {
        entry.Description = GetDescription(item);
    }

    ObjBagSetBagEntry(bag, entry);

    if(newStackSize == 0)
    {
        AssignCommand(item, SetIsDestroyable(TRUE));
        DestroyObject(item);
    }
    else
    {
        SetItemStackSize(item, newStackSize);
    }

    ObjBagSetAndUpdateCurrentWeight(bag, newWeight);

    return added;
}

// Removes amount quantity of the item matching the key from the bag.
// Returns the amount removed.
// If amount is -1, remove 1 stack, if amount is OBJ_INT_MAX, remove all of the item
int ObjBagRemoveItemFromBag(object bag, object addTo, string key, int amount)
{
    int removed = 0;
    return removed;
}

// Iterates inventory and adds all valid items to the bag until it is full or all valid items are vaccuumed
// Returns the number of items added to the bag
int ObjBagVaccuumItemsIntoBag(object container, object bag)
{
    object item = GetFirstItemInInventory(container);
    int maxitems = ObjBagGetMaxItemsForBag(bag);

    int currentcount = ObjBagItemCountInBag();
    int itemsadded = 0;

    int addedamount = 0;
    while(GetIsObjectValid(item) && currentcount < maxitems)
    {
        if(ObjBagIsValidItemForBag(bag, item) == TRUE)
        {
            addedamount = ObjBagAddItemToBag(bag, item);
            itemsadded += addedamount;
            currentcount += addedamount;
        }

        item = GetNextItemInInventory();
    }
    return itemsadded;
}

// Called when the bag's ability is triggered. Returns TRUE to indicate a conversation with the bag should be started, FALSE otherwise.
int ObjBagActivated(object player, object bag, object target)
{
    if(ObjBagItemIsCraftBag(bag) == FALSE)
    {
        return FALSE; // This isn't a crafting bag, nothing to do here
    }

    if(target == player || target == bag)
    {
        // Start convo with bag to get items out / vaccuum up items
        return TRUE;
    }

    string tag = GetTag(target);

    if(ObjBagIsValidItemForBag(bag, tag) == TRUE)
    {
        int added = ObjBagAddItemToBag(bag, target);

        if(added = 0)
        {
            return FALSE; // Couldn't add the item
        }
    }
    
    return FALSE;
}