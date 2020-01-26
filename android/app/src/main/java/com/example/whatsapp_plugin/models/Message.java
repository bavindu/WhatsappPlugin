package com.example.whatsapp_plugin.models;

import java.util.Date;

public class Message {
    private String id;
    private String sender;
    private String text;
    private String groupName;
    private boolean isGroupMessage;
    private String date;



    public Message(String sender, String text, String date, boolean isGroupMessage, String groupName) {
        this.sender = sender;
        this.text = text;
        this.date = date;
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

    public String getDate() {
        return date;
    }

    public boolean isGroupMessage() {
        return isGroupMessage;
    }
}
