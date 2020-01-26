package com.example.whatsapp_plugin.utils;

import android.os.Bundle;

import com.example.whatsapp_plugin.database.WPMessage;
import com.example.whatsapp_plugin.models.Message;
import com.google.gson.Gson;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CommonHelper {

    private static  CommonHelper instance;
    private Gson gson;
    private SimpleDateFormat simpleDateFormat;

    private CommonHelper () {
        simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        gson = new Gson();
    }


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
        Date date = new Date();
        String formatedDate = simpleDateFormat.format(date);
        message = new Message(sender, text, formatedDate, isGroupMessage, groupName);
        return message;
    }

    public List<String> parseList(List<WPMessage> wpMessageList) {
        ArrayList<String> stringMsgList = new ArrayList<>();
        for (int i = 0; i < wpMessageList.size(); i++) {
            String message = gson.toJson(wpMessageList.get(i));
            stringMsgList.add(message);
        }
        return  stringMsgList;
    }
}
