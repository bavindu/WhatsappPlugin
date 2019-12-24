package com.example.whatsapp_plugin.models;

import java.util.Date;

public class Message {
    private String sender;
    private String text;
    private String groupName;
    private boolean isGroupMessage;
    private Date date;

    public Message(String sender, String text,Date date, boolean isGroupMessage, String groupName) {
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

    public Date getDate() {
        return date;
    }
}
