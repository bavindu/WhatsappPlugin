package com.example.whatsapp_plugin;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;

public class NotificationManager extends NotificationListenerService {

    @Override
    public void onNotificationPosted(StatusBarNotification sbn, RankingMap rankingMap) {
        String packageName;
        super.onNotificationPosted(sbn, rankingMap);
        packageName = sbn.getPackageName();
        Log.i("Notification",sbn.getPackageName());
        if (packageName.equals("com.whatsapp")) {
            Log.i("Notification",sbn.getNotification().extras.toString());
        }
    }
}

