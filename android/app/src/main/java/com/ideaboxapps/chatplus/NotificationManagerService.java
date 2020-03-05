package com.ideaboxapps.chatplus;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;

import com.ideaboxapps.chatplus.database.MessageRepositary;
import com.ideaboxapps.chatplus.database.WPMessage;
import com.ideaboxapps.chatplus.models.Message;
import com.ideaboxapps.chatplus.utils.CommonHelper;
import com.google.gson.Gson;



public class NotificationManagerService extends NotificationListenerService {

    MessageRepositary messageRepositary;
    Gson gson = new Gson();

    @Override
    public void onCreate() {
        super.onCreate();
        this.messageRepositary = new MessageRepositary(this);
    }

    @Override
    public void onNotificationPosted(StatusBarNotification sbn, RankingMap rankingMap) {
        String packageName;
        super.onNotificationPosted(sbn, rankingMap);
        packageName = sbn.getPackageName();

        if (packageName.equals("com.whatsapp")
                && (sbn.getNotification().extras.get("android.isGroupConversation") != null)) {
            String sbnId = Long.toString(sbn.getNotification().when);
            boolean isAlreadyExists = messageRepositary.checkAlreadyExists(sbnId);
            if (!isAlreadyExists) {
                Message message = CommonHelper.getCommonHelperInstance().parseMessage(sbn.getNotification().extras);
                WPMessage wpMessage = new WPMessage(
                        sbnId,
                        message.getSender(),
                        message.getText(),
                        message.getGroupName(),
                        message.isGroupMessage()
                );
                MainActivity.methodChanel.invokeMethod("getMessage", gson.toJson(wpMessage));
                messageRepositary.insertMessage(wpMessage);
            } else {
                Log.i("NotficationActual","Already exists ");
            }

        }
    }

}

