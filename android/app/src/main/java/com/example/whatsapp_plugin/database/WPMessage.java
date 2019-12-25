package com.example.whatsapp_plugin.database;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

import java.util.Date;

@Entity
public class WPMessage {



    @PrimaryKey (autoGenerate = true)
    private int id;
    private String sender;
    private String text;
    private  String groupName;
    private boolean isGroupMessage;
    private String date;

    public WPMessage(String sender, String text, String groupName, boolean isGroupMessage, String date){
        this.sender = sender;
        this.text = text;
        this.groupName = groupName;
        this.isGroupMessage = isGroupMessage;
        this.date = date;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
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


    public String getDate() {
        return date;
    }

    public boolean getIsGroupMessage() {
        return isGroupMessage;
    }
}
