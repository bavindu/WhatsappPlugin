package com.ideaboxapps.chatplus.utils;


import android.os.Bundle;

import com.google.gson.JsonObject;
import com.ideaboxapps.chatplus.database.WPMessage;
import com.ideaboxapps.chatplus.models.Message;


import java.util.ArrayList;
import java.util.List;

public class CommonHelper {

    private static  CommonHelper instance;



    public static synchronized CommonHelper getCommonHelperInstance() {
        if (instance == null) {
            instance = new CommonHelper();
        }
        return  instance;
    }

    public  Message parseMessage(Bundle messageBundle) {
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
            int brackretIndex = conversationTitle.indexOf("(");
            if (brackretIndex != -1) {
                groupName = conversationTitle.substring(0,brackretIndex).trim();
            } else {
                groupName = conversationTitle;
            }
        } else {
            groupName = "NA";
        }
        message = new Message(sender, text, isGroupMessage, groupName);
        return message;
    }

    public List<String> parseList(List<WPMessage> wpMessageList) {
        ArrayList<String> stringMsgList = new ArrayList<>();
        for (int i = 0; i < wpMessageList.size(); i++) {
            JsonObject jsonObject = new JsonObject();
            WPMessage wpMessage = wpMessageList.get(i);
            jsonObject.addProperty("id",wpMessage.getId());
            jsonObject.addProperty("groupName",wpMessage.getGroupName());
            jsonObject.addProperty("isGroupMessage",wpMessage.getIsGroupMessage());
            jsonObject.addProperty("text",wpMessage.getText());
            jsonObject.addProperty("sender",wpMessage.getSender());
            stringMsgList.add(jsonObject.toString());
        }
        return  stringMsgList;
    }

}
