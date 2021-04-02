/**
 * @description An implementation of IHandleMessages which validates the passed in Lead and inserts it.
 */
public with sharing class IncomingLeadHandler implements IHandleMessages {
    @testVisible private static final String INCOMING_LEAD_CHANNEL = 'IncomingLeads';
    @testVisible private static final String CHANNEL_PARAM = 'channel';

    /**
     * @description Constructs an instance of IncomingLeadHandler.
     */
    public IncomingLeadHandler() { }

    /**
     * @description Handles a message on a subscribed channel.
     * @param channel The channel emitting the message.
     * @param data The accompanying data for the message.
     * @throws ArgumentNullException if channel is null.
     * @throws ArgumentException if the lead is missing a FirstName.
     */
    public void handleMessage(String channel, Object data) {
        ArgumentNullException.throwIfNull(channel, CHANNEL_PARAM);
        //check if object is lead and channel is lead channel
        if (!(data instanceof Lead) || !channel.equalsIgnoreCase(INCOMING_LEAD_CHANNEL)) {
            return;
        }
        Lead leadToInsert = (Lead)data;
        if(leadToInsert.FirstName == null){
            //throw exception for invalid lead
            throw new ArgumentException('The lead does not have a valid first name.');
        }else{
            //Insert valid lead
            Database.insert(leadToInsert);
        }

    }

    /**
     * @description Gets a list of channels an implementation subscribes to.
     * @return A List<String> of channel names this implementation is subscribed to.
     */
    public List<String> getSubscribedChannels() {
         return new List<String> {
                    INCOMING_LEAD_CHANNEL
            };
    }
}