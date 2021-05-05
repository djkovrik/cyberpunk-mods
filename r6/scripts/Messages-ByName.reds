
import flib._common.sort.*
import flib.JournalContact.*

@replaceMethod(MessengerUtils)
public final static func GetContactDataArray(journal: ref<JournalManager>, includeUnknown: Bool, skipEmpty: Bool, activeDataSync: wref<MessengerContactSyncData>) -> array<ref<VirutalNestedListData>> {
  let i: Int32;
  let j: Int32;
  let conversationsCount: Int32;
  let context: JournalRequestContext;
  let entries: array<wref<JournalEntry>>;
  let contactEntry: wref<JournalContact>;
  let conversationEntry: wref<JournalPhoneConversation>;
  let conversations: array<wref<JournalEntry>>;
  let messagesReceived: array<wref<JournalEntry>>;
  let playerReplies: array<wref<JournalEntry>>;
  let contactData: ref<ContactData>;
  let threadData: ref<ContactData>;
  let contactVirtualListData: ref<VirutalNestedListData>;
  let threadVirtualListData: ref<VirutalNestedListData>;
  let virtualDataList: array<ref<VirutalNestedListData>>;

  context.stateFilter.active = true;
  journal.GetContacts(context, entries);
  
  //let comparator = new SortContactsByNameComparator();
  //QuicksortContacts.SortArray(journal, entries, comparator);
  Quicksort.SortArray(
    JournalEntryArrayWrapper.Create(entries) as ArrayWrapper,
    JournalContactByNameComparator.Create(journal) as Comparator
  );

  Log("Sorted!");

  i = 0;
  while i < ArraySize(entries) {
    contactEntry = (entries[i] as JournalContact);
    if includeUnknown || contactEntry.IsKnown(journal) {
      ArrayClear(messagesReceived);
      ArrayClear(playerReplies);
      journal.GetConversations(contactEntry, conversations);
      journal.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);
      if skipEmpty && ArraySize(messagesReceived) < 0 && ArraySize(playerReplies) < 0 {
      } else {
        contactData = new ContactData();
        contactData.id = contactEntry.GetId();
        contactData.hash = journal.GetEntryHash(contactEntry);
        contactData.localizedName = contactEntry.GetLocalizedName(journal);
        contactData.avatarID = contactEntry.GetAvatarID(journal);
        contactData.timeStamp = journal.GetEntryTimestamp(contactEntry);
        contactData.activeDataSync = activeDataSync;
        MessengerUtils.GetContactMessageData(contactData, journal, messagesReceived, playerReplies);
        contactVirtualListData = new VirutalNestedListData();
        contactVirtualListData.m_level = i;
        contactVirtualListData.m_widgetType = Cast(0);
        contactVirtualListData.m_isHeader = true;
        contactVirtualListData.m_data = contactData;
        conversationsCount = ArraySize(conversations);
        if conversationsCount > 1 {
          contactVirtualListData.m_collapsable = true;
          j = 0;
          while j < conversationsCount {
            ArrayClear(messagesReceived);
            ArrayClear(playerReplies);
            conversationEntry = (conversations[j] as JournalPhoneConversation);
            journal.GetMessagesAndChoices(conversationEntry, messagesReceived, playerReplies);
            threadData = new ContactData();
            threadData.id = conversationEntry.GetId();
            threadData.hash = journal.GetEntryHash(conversationEntry);
            threadData.localizedName = conversationEntry.GetTitle();
            threadData.timeStamp = journal.GetEntryTimestamp(conversationEntry);
            threadData.activeDataSync = activeDataSync;
            MessengerUtils.GetContactMessageData(threadData, journal, messagesReceived, playerReplies);
            threadVirtualListData = new VirutalNestedListData();
            threadVirtualListData.m_collapsable = false;
            threadVirtualListData.m_isHeader = false;
            threadVirtualListData.m_level = i;
            threadVirtualListData.m_widgetType = Cast(1);
            threadVirtualListData.m_data = threadData;
            ArrayPush(virtualDataList, threadVirtualListData);
            j += 1;
          };
        } else {
          contactVirtualListData.m_collapsable = false;
        };
        ArrayPush(virtualDataList, contactVirtualListData);
      };
    };
    i += 1;
  };
  return virtualDataList;
}
