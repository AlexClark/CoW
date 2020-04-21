
#include "nwnx_creature"
#include "nwnx_object"
#include "inc_zdlg"
#include "inc_holders"
#include "zzdlg_color_inc"
#include "inc_stacking"
#include "obj_craftbag"


const string OBJECTOPTIONS = "OBJECTOPTIONS";
const string OBJECTIDS = "OBJECTIDS";

const string PAGE_DONE    = "DONE";
const string PAGE_FAILED  = "FAILED";

const string CRAFTBAG_ALL_OPTION = "ALL";
const string CRAFTBAG_DONE_OPTION = "DONE";


void Init()
{

  // make sure the list of objects is always accurate
  DeleteList(OBJECTOPTIONS);
  DeleteList(OBJECTIDS);

  if (GetElementCount(OBJECTOPTIONS) == 0)
  {
    // retrieve the object name and qty from the local variables on the container object (see gvd_inc_keychain for details)
    object oPC   = GetPcDlgSpeaker();
    object oContainer = GetLocalObject(oPC, OBJ_CRAFTBAG_CONV_KEY);

    //Vacuum all items option
    AddStringElement(txtLime + "[Place all suitable inventory items into container]</c>", OBJECTOPTIONS);
    AddStringElement(CRAFTBAG_ALL_OPTION, OBJECTIDS);

    // iterate bag contents, displaying options for each
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

        struct ObjBagKey bagkey = ObjBagParseBagItemKey(key);

        string entrytext = GetLocalString(bag, key);

        int count = ObjBagGetCountFromBagEntryText(entrytext);

        // add name to list for PC
        AddStringElement(bagkey.Name + " (" + IntToString(count) + ")", OBJECTOPTIONS);

        // add variable name holding resref and tag and name to list for item creation
        AddStringElement(key, OBJECTIDS);
    }

    // always add, a done option
    AddStringElement(txtLime + "[Done]</c>", OBJECTOPTIONS);
    AddStringElement(CRAFTBAG_DONE_OPTION, OBJECTIDS);

  }
}


void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oContainer = GetLocalObject(oPC, OBJ_CRAFTBAG_CONV_KEY);

  if (sPage == "")
  {
    SetDlgPrompt("What item do you wish to retrieve from the " + GetName(oContainer) + "?");
    SetDlgResponseList(OBJECTOPTIONS);
  }
  else if (sPage == PAGE_DONE)
  {
    SetDlgPrompt("You retrieve the item.\nWhat item do you wish to retrieve from the " + GetName(oContainer) + "?");
    Init();
    SetDlgPageString("");
    SetDlgResponseList(OBJECTOPTIONS);
  }
  else if (sPage == PAGE_FAILED)
  {
    SetDlgPrompt("You can't find the item you are looking for.");
  }
}


void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object player  = GetPcDlgSpeaker();
  string page    = GetDlgPageString();

  if (page == "") 
  {
    // handle the PCs selection
    object bag = GetLocalObject(oPC, OBJ_CRAFTBAG_CONV_KEY);
    string key = GetStringElement(selection, OBJECTIDS);
    int isValidKey = ObjBagIsBagEntryKey(key);

    if(key == CRAFTBAG_ALL_OPTION) //loop through inventory, add items
    {
        int added = ObjBagVaccuumItemsIntoBag(oPC, bag);
        EndDlg();
    }
    else if(key == CRAFTBAG_DONE_OPTION) 
    {
        // The Done response list has only one option, to end the conversation.
        EndDlg();
    }
    else if(isValidKey == TRUE)
    {
        int removed = ObjBagRemoveItemFromBag(bag, player, key, OBJ_MAX_ITEM_QUANTITY);
        SetDlgPageString(PAGE_DONE);
    }
    else 
    {
        SetDlgPageString(PAGE_FAILED);
    }
  } 
  else 
  {
    // The Done response list has only one option, to end the conversation.
    EndDlg();
  }

}


void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}