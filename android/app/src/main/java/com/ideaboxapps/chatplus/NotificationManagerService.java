package com.ideaboxapps.chatplus;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;
import android.widget.Toast;

import com.google.gson.JsonObject;
import com.ideaboxapps.chatplus.database.MessageRepositary;
import com.ideaboxapps.chatplus.database.WPMessage;
import com.ideaboxapps.chatplus.models.Message;
import com.ideaboxapps.chatplus.utils.CommonHelper;




public class NotificationManagerService extends NotificationListenerService {

    MessageRepositary messageRepositary;

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
                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty("id",wpMessage.getId());
                jsonObject.addProperty("groupName",wpMessage.getGroupName());
                jsonObject.addProperty("isGroupMessage",wpMessage.getIsGroupMessage());
                jsonObject.addProperty("text",wpMessage.getText());
                jsonObject.addProperty("sender",wpMessage.getSender());
                try {
                    MainActivity.methodChanel.invokeMethod("getMessage", jsonObject.toString());
                }catch (NullPointerException e) {
                    e.printStackTrace();
                }
                messageRepositary.insertMessage(wpMessage);
            } else {
                Log.i("NotficationActual","Already exists ");
            }

        }
    }

}

