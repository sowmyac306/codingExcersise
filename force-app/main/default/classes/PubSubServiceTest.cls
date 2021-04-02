@isTest
private class PubSubServiceTest {
    public static final String INCOMING_CONTACT_CHANNEL = 'IncomingContacts';
    private static final String EXPECTED_ASSISTANT_NAME = 'Gordon Freeman';

    private static List<Contact> getContacts() {
        return [SELECT Id, FirstName, LastName, AssistantName FROM Contact];
    }

    @isTest
    private static void handleMessage_withContact_expectInsertedWithAlteredAssistantName() {
        Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Tester',
                AssistantName = 'None');

        IHandleMessages testHandler = new IncomingContactHandler();
        PubSubService.Instance.subscribe(testHandler);

        List<Contact> contacts = getContacts();

        System.assert(contacts.isEmpty(), 'Expected no contacts.');

        Test.startTest();
        PubSubService.Instance.emit(INCOMING_CONTACT_CHANNEL, testContact);
        Test.stopTest();

        contacts = getContacts();

        System.assertEquals(1, contacts.size(), 'Expected one contact.');
        System.assertEquals(testContact.FirstName, contacts[0].FirstName, 'Expected the test contact.');
        System.assertEquals(EXPECTED_ASSISTANT_NAME, contacts[0].AssistantName,
                'Expected the interface implementation to have altered the assistant name.');
    }

    /**
     * @description A test implementation of IHandleMessages which alters the passed in Contact and inserts it.
     */
    public class IncomingContactHandler implements IHandleMessages {
        /**
         * @description Handles a message on a subscribed channel.
         * @param channel The channel emitting the message.
         * @param data The accompanying data for the message.
         */
        public void handleMessage(String channel, Object data) {
            if (!(data instanceof Contact) || !channel.equalsIgnoreCase(INCOMING_CONTACT_CHANNEL)) {
                return;
            }

            Contact contactToInsert = (Contact)data;
            contactToInsert.AssistantName = EXPECTED_ASSISTANT_NAME;

            Database.insert(contactToInsert);
        }

        /**
         * @description Gets a list of channels an implementation subscribes to.
         * @return A List<String> of channel names this implementation is subscribed to.
         */
        public List<String> getSubscribedChannels() {
            return new List<String> {
                    INCOMING_CONTACT_CHANNEL
            };
        }
    }
}