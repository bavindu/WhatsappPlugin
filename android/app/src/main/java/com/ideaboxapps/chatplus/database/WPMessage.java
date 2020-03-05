package com.ideaboxapps.chatplus.database;

import androidx.annotation.NonNull;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public class WPMessage {



    @PrimaryKey
    @NonNull
    private String id;
    private String sender;
    private String text;
    private  String groupName;
    private boolean isGroupMessage;

    public WPMessage(String id, String sender, String text, String groupName, boolean isGroupMessage){
        this.id = id;
        this.sender = sender;
        this.text = text;
        this.groupName = groupName;
        this.isGroupMessage = isGroupMessage;
    }


    public String getId() {
        return id;
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

    public boolean getIsGroupMessage() {
        return isGroupMessage;
    }
}
