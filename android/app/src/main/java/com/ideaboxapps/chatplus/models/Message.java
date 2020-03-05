package com.ideaboxapps.chatplus.models;

public class Message {
    private String id;
    private String sender;
    private String text;
    private String groupName;
    private boolean isGroupMessage;



    public Message(String sender, String text, boolean isGroupMessage, String groupName) {
        this.sender = sender;
        this.text = text;
        this.isGroupMessage = isGroupMessage;
        this.groupName = groupName;
    }

    public String getSender() {
        return sender;
    }

    public String getText() {
        return text;
    }

    public String getGroupName() {
        return groupName;
    }

    public boolean isGroupMessage() {
        return isGroupMessage;
    }
}
