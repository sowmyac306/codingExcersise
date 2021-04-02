/**
 * @description A simple Pub/Sub pattern implementation
 */
public with sharing class PubSubService {
    private static final String CHANNEL = 'channel';


    IHandleMessages handler = null;
    Map<String, IHandleMessages> handlerByChannelName = new Map<String, IHandleMessages>();
    private PubSubService() { }

    /**
     * @description A singleton for service interaction.
     */
    public static PubSubService Instance {
        get {
            if (Instance == null) {
                Instance = new PubSubService();
            }

            return Instance;
        }

        private set;
    }

    /**
     * @description Subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void subscribe(IHandleMessages implementation) {
        if(implementation == null){
            ArgumentNullException.throwIfNull(implementation);
        }
        // get all channels from handler
        List<String> channelNames = implementation.getSubscribedChannels();
        for(String channelName : channelNames){
            handlerByChannelName.put(channelName, implementation);
        }
        
    }

    /**
     * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void unsubscribe(IHandleMessages implementation) {
        if(implementation == null){
            ArgumentNullException.throwIfNull(implementation);
        }
        Set<String> subscribedChannels = handlerByChannelName.keyset();
        for(String channelName :  implementation.getSubscribedChannels()){
            if(subscribedChannels.contains(channelName)){
                handlerByChannelName.remove(channelName);
            }
        }
    }

    /**
     * @description Emits a message to a given channel containing the specified data.
     * @param channel The channel to emit a message on.
     * @param data The data to emit.
     * @throws ArgumentNullException if channel is null.
     */
    public void emit(String channel, Object data) {
        ArgumentNullException.throwIfNull(channel, CHANNEL);
        handler = handlerByChannelName.get(channel);
        if(handler != null){
            handler.handleMessage(channel, data);
        }
    }
}