package com.example.whatsapp_plugin;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import com.example.whatsapp_plugin.database.MessageRepositary;
import com.example.whatsapp_plugin.database.WPMessage;
import com.example.whatsapp_plugin.models.Message;
import com.example.whatsapp_plugin.utils.CommonHelper;

public class NotificationManagerService extends NotificationListenerService {

    String lastNotificationKey = null;
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
                && (sbn.getNotification().extras.get("android.isGroupConversation") != null)
                && !sbn.getKey().equals(lastNotificationKey)) {
            Message message = CommonHelper.getCommonHelperInstance().parseMessage(sbn.getNotification().extras);
            MainActivity.methodChanel.invokeMethod("getMessage",message.getText());
            lastNotificationKey = sbn.getKey();
            messageRepositary.insertMessage(
                    new WPMessage(
                            message.getSender(),
                            message.getText(),
                            message.getGroupName(),
                            message.isGroupMessage(),
                            message.getDate()
                    )
            );
        }
    }
}

