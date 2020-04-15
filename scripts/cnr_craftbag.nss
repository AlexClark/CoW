/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_craftbag_act
//
//  Desc:  This is a custom handler for crafting bag containers
//         ObjectTag based activation logic.
//         Handles loading object tags that can be stored in the bag,
//         and storing and removing said items.
//
//  Author: Alex Clark 13APR20
//
/////////////////////////////////////////////////////////

const int CNR_INT_MAX = 2147483647;
const int CNR_MAX_ITEM_QUANTITY = 9999;
const int CNR_MAX_ITEM_QUANTITY_LENGTH = 4;

const string CNR_CRAFTBAG_PREFIX = "CNR_BAG_";
const int CNR_CRAFTBAG_PREFIX_LENGTH = 8;

const string CNR_CRAFTBAG_LIST_PREFIX = "CNR_BAG_LIST_";
const int CNR_CRAFTBAG_LIST_PREFIX_LENGTH = 13;

const string CNR_CRAFTBAG_ENTRY_PREFIX = "CNRITM";
const int CNR_CRAFTBAG_ENTRY_PREFIX_LENGTH = 6;
const string CNR_CRAFTBAG_ENTRY_DIVIDER = "||";
const int CNR_CRAFTBAG_ENTRY_DIVIDER_LENGTH = 2;

//Struct declaration for bag entries
struct CnrBagEntry
{
    int Count;
    string ResRef;
    string Tag;
    string Name;
    string Description;
};


string CnrBagGetBagList(string type)
{
    GetLocalString(GetModule(), CNR_CRAFTBAG_LIST_PREFIX + type);
}

void CnrBagInitList(object mod, string type, string list)
{
    SetLocalString(mod, CNR_CRAFTBAG_LIST_PREFIX + type, list);
}

// Initialize module data store of valid items for craft bags
void CnrBagInit()
{
    object mod = GetModule();

    CnrBagInitList(mod, "HERB", 
          "cnrangelicaleaf,cnrwalnutfruit,cnraloeleaf,cnrgarlicclove,cnrcloverleaf,cnrsageleaf,"
        + "cnrpepmintleaf,cnrbirchbark,cnralmondfruit,cnrginsengroot,cnrgingerroot,cnrcomfreyroot,cnrhawthornfwr,"
        + "cnrcatnipleaf,cnrhazelleaf,cnrcalendulafwr,cnrchestnutfruit,cnrpecanfruit,cnrnettleleaf,"
        + "cnrskullcapleaf,cnrthistleleaf,cnrechinacearoot,cnrchamomilefwr");

    CnrInitList(mod, "GEMS",
        "");

}

// returns the count of items when provided the value text from an item entry
int CnrBagGetCountFromBagEntryText(string entry)
{
    return StringToInt(GetStringLeft(entry, CNR_MAX_ITEM_QUANTITY_LENGTH));
}

// Parses a key/value pair for a bag item entry, and returns the entry struct
struct CnrBagEntry CnrBagParseBagEntry(string key, string entrytext)
{
    struct CnrBagEntry entry;
    entry.Count = CnrBagGetCountFromBagEntryText(entrytext);

    int parseloc = CNR_CRAFTBAG_ENTRY_PREFIX_LENGTH;
    int div = FindSubString(key, CNR_CRAFTBAG_ENTRY_DIVIDER, parseloc);

    entry.ResRef = GetSubString(key, parseloc, div - parseloc);

    parseloc = div + CNR_CRAFTBAG_ENTRY_DIVIDER_LENGTH;
    div = FindSubString(key, CNR_CRAFTBAG_ENTRY_DIVIDER, parseloc);

    entry.Tag = GetSubString(key, parseloc, div - parseloc);

    parseloc = div + CNR_CRAFTBAG_ENTRY_DIVIDER_LENGTH;

    entry.Name = GetSubString(key, parseloc, CNR_INT_MAX);
    entry.Description = GetSubString(entrytext, CNR_MAX_ITEM_QUANTITY_LENGTH, CNR_INT_MAX);

    return entry;
}

// serializes the string value for an entry
string CnrBagSerializeBagEntryText(struct CnrBagEntry entry)
{
    return IntToString(entry.Count) + entry.Description;
}

// generates the key for an entry
string CnrBagGenerateBagEntryKey(struct CnrBagEntry entry)
{
    return CNR_CRAFTBAG_ENTRY_PREFIX + entry.ResRef + CNR_CRAFTBAG_ENTRY_DIVIDER + entry.Tag + CNR_CRAFTBAG_ENTRY_DIVIDER + entry.Name;
}

// generates the key the given item would use for a bag entry
string CnrBagGenBagEntryKeyForItem(object item)
{
    return CNR_CRAFTBAG_ENTRY_PREFIX + GetResRef(item) + CNR_CRAFTBAG_ENTRY_DIVIDER + GetTag(item) + CNR_CRAFTBAG_ENTRY_DIVIDER + GetName(item);
}

// parses the given tag for the bag, and checks the item tag provided to see if it is a valid item type for the bag
int CnrBagIsValidTagForBag(string bag, string item)
{
    string type = GetStringUpperCase(GetSubString(bag, CNR_CRAFTBAG_PREFIX_LENGTH, CNR_INT_MAX));

    if(type == "")
    {
        return FALSE; // something went wrong, this is not a bag
    }

    string list = CnrBagGetBagList(type);
    int index = FindSubString(list, item);
    if(index == -1) {return FALSE;}
    return TRUE;
}

// checks if the given item can be stored in the given bag. does not check if the bag item is a bag.
int CnrBagIsValidItemForBag(object bag, object item)
{
    int ret = CnrBagIsValidTagForBag(GetTag(bag), GetTag(item));
    if(ret == TRUE && GetDroppableFlag(target) == TRUE && GetItemCursedFlag(target) == FALSE) {return TRUE;}
    return FALSE;
}

//returns true if the item is a craftbag, false otherwise
int CnrBagItemIsCraftBag(object item)
{
    string bagtag = GetTag(item);
    if(GetStringLeft(bagtag, CNR_CRAFTBAG_PREFIX_LENGTH) != CNR_CRAFTBAG_PREFIX)
    {
        return FALSE; // This isn't a crafting bag, nothing to do here
    }
}

int CnrBagGetMaxItemsForBag(object bag)
{
    return 500;
}

// returns total count of all items in the bag
int CnrBagGetCurrentItemsInBag(object bag)
{
    return -1;
}

// returns the count of items currently in the bag for a given item
int CnrBagItemCountInBag(object bag, object item)
{
    return -1;
}

// Adds the item to the bag, returns amount of the stack added to the bag, or 0 for failure
// Does not check for validity, you should check first with CnrBagIsValidItemForBag()
int CnrBagAddItemToBag(object bag, object item)
{
    return 0;
}

// Removes amount quantity of the item matching the key from the bag.
// Returns the amount removed.
// If amount is -1, remove 1 stack, if amount is CNR_INT_MAX, remove all of the item
int CnrBagRemoveItemFromBag(object bag, object addTo, string key, int amount)
{
    return 0;
}

// Iterates inventory and adds all valid items to the bag until it is full or all valid items are vaccuumed
// Returns the number of items added to the bag
int CnrBagVaccuumItemsIntoBag(object container, object bag)
{
    object item = GetFirstItemInInventory(container);
    int maxitems = CnrBagGetMaxItemsForBag(bag);

    int currentcount = CnrBagItemCountInBag();
    int itemsadded = 0;

    int addedamount = 0;
    while(GetIsObjectValid(item) && currentcount < maxitems)
    {
        if(CnrBagIsValidItemForBag(bag, GetTag(item)) == TRUE)
        {
            addedamount = CnrBagAddItemToBag(bag, item);
            itemsadded += addedamount;
            currentcount += addedamount;
        }

        item = GetNextItemInInventory();
    }
    return itemsadded;
}

// Called when the bag's ability is triggered. Returns TRUE to indicate a conversation with the bag should be started, FALSE otherwise.
int CnrBagActivated(object player, object bag, object target)
{
    if(CnrBagItemIsCraftBag(bag) == FALSE)
    {
        return FALSE; // This isn't a crafting bag, nothing to do here
    }

    if(target == player || target == bag)
    {
        // Start convo with bag to get items out / vaccuum up items
        return TRUE;
    }

    string tag = GetTag(target);

    if(CnrBagIsValidItemForBag(bag, tag) == TRUE)
    {
        int added = AddItemToBag(bag, target);

        if(added = 0)
        {
            return FALSE; // Couldn't add the item
        }
    }
    
    return FALSE;
}