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

//Struct declaration for bag entries
struct ObjBagEntry
{
    int Count;
    string ResRef;
    string Tag;
    string Name;
    string Description;
};


string ObjBagGetBagList(string type)
{
    GetLocalString(GetModule(), OBJ_CRAFTBAG_LIST_PREFIX + type);
}

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

// Parses a key/value pair for a bag item entry, and returns the entry struct
struct ObjBagEntry ObjBagParseBagEntry(string key, string entrytext)
{
    struct ObjBagEntry entry;
    entry.Count = ObjBagGetCountFromBagEntryText(entrytext);

    int parseloc = OBJ_CRAFTBAG_ENTRY_PREFIX_LENGTH;
    int div = FindSubString(key, OBJ_CRAFTBAG_ENTRY_DIVIDER, parseloc);

    entry.ResRef = GetSubString(key, parseloc, div - parseloc);

    parseloc = div + OBJ_CRAFTBAG_ENTRY_DIVIDER_LENGTH;
    div = FindSubString(key, OBJ_CRAFTBAG_ENTRY_DIVIDER, parseloc);

    entry.Tag = GetSubString(key, parseloc, div - parseloc);

    parseloc = div + OBJ_CRAFTBAG_ENTRY_DIVIDER_LENGTH;

    entry.Name = GetSubString(key, parseloc, OBJ_INT_MAX);
    entry.Description = GetSubString(entrytext, OBJ_MAX_ITEM_QUANTITY_LENGTH, OBJ_INT_MAX);

    return entry;
}

// serializes the string value for an entry
string ObjBagSerializeBagEntryText(struct ObjBagEntry entry)
{
    return IntToString(entry.Count) + entry.Description;
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

// parses the given tag for the bag, and checks the item tag provided to see if it is a valid item type for the bag
int ObjBagIsValidTagForBag(string bag, string item)
{
    string type = GetStringUpperCase(GetSubString(bag, OBJ_CRAFTBAG_PREFIX_LENGTH, OBJ_INT_MAX));

    if(type == "")
    {
        return FALSE; // something went wrong, this is not a bag
    }

    string list = ObjBagGetBagList(type);
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

int ObjBagGetMaxItemsForBag(object bag)
{
    return 500;
}

// returns total count of all items in the bag
int ObjBagGetCurrentItemsInBag(object bag)
{
    return -1;
}

// returns the count of items currently in the bag for a given item
int ObjBagItemCountInBag(object bag, object item)
{
    return -1;
}

// Adds the item to the bag, returns amount of the stack added to the bag, or 0 for failure
// Does not check for validity, you should check first with ObjBagIsValidItemForBag()
int ObjBagAddItemToBag(object bag, object item)
{
    return 0;
}

// Removes amount quantity of the item matching the key from the bag.
// Returns the amount removed.
// If amount is -1, remove 1 stack, if amount is OBJ_INT_MAX, remove all of the item
int ObjBagRemoveItemFromBag(object bag, object addTo, string key, int amount)
{
    return 0;
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
        int added = AddItemToBag(bag, target);

        if(added = 0)
        {
            return FALSE; // Couldn't add the item
        }
    }
    
    return FALSE;
}