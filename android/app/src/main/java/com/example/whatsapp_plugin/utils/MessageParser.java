package com.example.whatsapp_plugin.utils;

import android.os.Bundle;

import com.example.whatsapp_plugin.models.Message;

import java.util.Date;

public class MessageParser {

    public static Message parseMessage(Bundle messageBundle) {
        Message message;
        boolean isGroupMessage = false;
        String groupName = null;
        String text = messageBundle.get("android.text").toString();
        String sender = messageBundle.get("android.title").toString();
        String isGroupConversation = messageBundle.get("android.isGroupConversation").toString();
        if (isGroupConversation.equals("true")) {
            isGroupMessage = true;
            String conversationTitle = messageBundle.get("android.conversationTitle").toString();
            sender = sender.substring(conversationTitle.length()+1).trim() ;
            int brackretIndex = conversationTitle.indexOf("Log.i(\"NotificationTest\",Integer.toString(sbn.getNotification().number));(");
            if (brackretIndex != -1) {
                groupName = conversationTitle.substring(0,brackretIndex);
            } else {
                groupName = conversationTitle;
            }
        } else {
            groupName = "No group";
        }
        Date date = new Date();
        message = new Message(sender, text, date, isGroupMessage, groupName);
        return message;
    }
}
