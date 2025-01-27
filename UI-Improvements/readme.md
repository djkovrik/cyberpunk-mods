# flib's UI Improvements

A collection of quality-of-life UI improvements to fix minor issues that annoyed me.

### Inventory
- Iconic Items cannot be disassembled
- Light Machine Gun weapon mods now actually work

### Crafting
- Ammo crafting is limited to the maximum carryable per type

### Journal
- Sort Jobs dynamically by timestamp/name/difficulty
- Sort Messages dynamically by timestamp/name
- Sort Shards dynamically by timestamp/name

### Dialer Menu
- Sorting by either name or timestamp (install time choice)
- Always shows contacts that are Quest Related or have unread messages first

### Vendors:
- Iconic Items cannot be sold
- Ripperdoc vendor screen only shows number of unowned mods per body category

## TODO
- [X] Limit ammo crafting to type limit
  - [X] Retrieve limit dynamically instead of hardcoded magic numbers
- [X] Sort menus dynamically
  - [X] Steal sorting widget from other controllers
- [ ] Fix displayed cost of installing owned cyberware in Vendor screen
- [ ] Show scope type in tooltip
- Looks like that information is stored in the TweakDB
- [ ] Add search filter to shards/messages
- [X] Add vehicle thumbnail images to vehicle quests (PR #1 by djkovrik)
  - [ ] Find non-hardcoded mapping between quests and images
  - Doesn't seem to exist, could be patched in to quest archive data
- [X] Fixing LMG weapon mods
- [ ] Add configuration tool (CET-based?)
- [ ] Add tagging of favourite items to prevent them being sold or disassembled

## Compatability

- Incompatible with my previous mod [Stop Accidentally Disassembling Iconics](https://www.nexusmods.com/cyberpunk2077/mods/2252) as it implements the same features
- Incompatible with [Sorted Menus](https://www.nexusmods.com/cyberpunk2077/mods/1439) as it implements the same functionality

## Credits
- jekky for the [redscript compiler](https://github.com/jac3km4/redscript)
- djkovrik for releasing mods implementing the same features but faster than me
- The [CP77 modding discord](https://discord.gg/Epkq79kd96)

-----

## For redscript devs

To prevent any possible future naming conflicts:
 - All added methods are `flib` prefixed
 - All added fields are `f_` prefixed

### Existing class modifications
```swift
class CodexUtils {
  // Replaced method
  public final static func GetShardsDataArray(journal: ref<JournalManager>, activeDataSync: wref<CodexListSyncData>) -> array<ref<VirutalNestedListData>>
}

class ContactData {
  // Added field
  public let f_parent: wref<ContactData>;
}

class CraftingSystem {
  // Added methods
  protected func flibGetAmmoCraftingMaximum(itemRecord: wref<Item_Record>) -> Int32
  protected func flibGetAmmoCraftingMaximum(itemData: wref<gameItemData>) -> Int32
  // Replaced methods
  public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32
  public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool
  public final const func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool
  public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool
}

class DialerContactDataView {
  // Replaced method
  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool
}

class JournalManager {
  // Replaced method
  public final func GetContactDataArray(includeUnknown: Bool) -> array<ref<IScriptable>>
}

class MessengerContactDataView {
  // Added method
  public static func flibGetContactFromListData(listData: ref<VirutalNestedListData>) -> ref<ContactData>
  // Added method that overrides parent class
  protected func PreSortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
}

class MessengerGameController {
  // Added fields
  private let f_sortOrder: flibSortOrder;
  private let f_uiScriptableSystem: wref<UIScriptableSystem>;
  // Added method
  protected cb func flibOnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool
  // Wrapped methods
  protected cb func OnInitialize() -> Bool
  protected cb func OnUninitialize() -> Bool
  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool
}

class MessengerUtils {
  // Replaced method
  public final static func GetContactDataArray(journal: ref<JournalManager>, includeUnknown: Bool, skipEmpty: Bool, activeDataSync: wref<MessengerContactSyncData>) -> array<ref<VirutalNestedListData>>
}

class QuestDetailsPanelController {
  // Replace method
  private final func SpawnMappinLink(mappinEntry: ref<JournalQuestMapPinBase>, jumpTo: Vector3) -> Void
}

class QuestListVirtualNestedDataView {
  // Replaced method
  protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void
}

class questLogGameController {
  // Added fields
  private let f_sortOrder: flibSortOrder;
  private let f_uiScriptableSystem: wref<UIScriptableSystem>;
  // Added method
  protected cb func flibOnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool
  // Wrapped methods
  protected cb func OnInitialize() -> Bool
  protected cb func OnUninitialize() -> Bool
  protected cb func OnQuestListItemHoverOver(e: ref<QuestListItemHoverOverEvent>) -> Bool
  protected cb func OnQuestObjectiveHoverOver(e: ref<QuestObjectiveHoverOverEvent>) -> Bool
  protected cb func OnQuestListItemHoverOut(e: ref<QuestListItemHoverOutEvent>) -> Bool
  protected cb func OnQuestObjectiveHoverOut(e: ref<QuestObjectiveHoverOutEvent>) -> Bool
}

class QuestMappinLinkController {
  // Added method
  public func flib_SetupVehicleIcon(questId: String) -> Void
}

class RipperDocGameController {
  // Replaced method
  private final func GetAmountOfAvailableItems(equipArea: gamedataEquipmentArea) -> Int32
}

class RPGManager {
  // Replaced method
  public final static func GetModsSlotIDs(type: gamedataItemType) -> array<TweakDBID>
}

class ShardEntryData {
  // Added field
  public let f_group: wref<ShardEntryData>;
}

class ShardsMenuGameController {
  // Added fields
  private let f_sortOrder: flibSortOrder;
  private let f_uiScriptableSystem: wref<UIScriptableSystem>;
  // Added method
  protected cb func flibOnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool
  // Wrapped methods
  protected cb func OnInitialize() -> Bool
  protected cb func OnUninitialize() -> Bool
  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool
  private final func RefreshButtonHints() -> Void
}

class ShardsNestedListDataView {
  // Added methods
  public static func flibGetShardGroupFromListData(listData: ref<VirutalNestedListData>) -> ref<ShardEntryData>
  // Added method that overrides parent class
  protected func PreSortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void
  // Replaced methods
  protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void
}

class UIScriptableSystem {
  // Added fields
  private let f_messagesSorting: Int32;
  private let f_questSorting: Int32;
  private let f_shardsSorting: Int32;
  // Added methods
  public final const func flibGetMessagesSorting() -> Int32
  public final const func flibGetQuestSorting() -> Int32
  public final const func flibGetShardsSorting()
  public final func flibSetMessagesSorting(mode: Int32) -> Void
  public final func flibSetQuestSorting(mode: Int32) -> Void
  public final func flibSetShardsSorting(mode: Int32) -> Void
}

class Vendor {
  // Replaced methods
  public final const func PlayerCanSell(itemID: ItemID, allowQuestItems: Bool, excludeEquipped: Bool) -> Bool
}

class VirtualNestedListController {
  // Added method
  public final func flibSetSortOrder(order: flibSortOrder) -> Void
}

class VirtualNestedListDataView {
  // Added field
  private let f_sortOrder: flibSortOrder;
  // Added method
  public final func flibSetSortOrder(order: flibSortOrder) -> Void
}
```

### New stuff
```swift
enum flibSortOrder {
  Timestamp = 0,
  Name = 1,
  Difficulty = 2
}

class flibSortingUtils {
  public static func GetButtonEventName() -> CName
  public static func GetSortOrderLocKey(order: flibSortOrder) -> CName
  public static func GetSortOrderButtonHint(order: flibSortOrder) -> String
}

public static func flib_GetVehicleIcon(questId: String) -> ref<UIIcon_Record>
```
