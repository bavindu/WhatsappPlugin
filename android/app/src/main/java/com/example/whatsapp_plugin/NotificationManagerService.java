package com.example.whatsapp_plugin;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;

import com.example.whatsapp_plugin.models.Message;
import com.example.whatsapp_plugin.utils.MessageParser;

public class NotificationManagerService extends NotificationListenerService {

    String lastNotificationKey = null;

    @Override
    public void onNotificationPosted(StatusBarNotification sbn, RankingMap rankingMap) {
        String packageName;
        super.onNotificationPosted(sbn, rankingMap);
        packageName = sbn.getPackageName();
        if (packageName.equals("com.whatsapp")
                && (sbn.getNotification().extras.get("android.isGroupConversation") != null)
                && !sbn.getKey().equals(lastNotificationKey)) {
            Message message = MessageParser.parseMessage(sbn.getNotification().extras);
            MainActivity.methodChanel.invokeMethod("getMessage",message.getText());
            lastNotificationKey = sbn.getKey();
        }
    }
}

