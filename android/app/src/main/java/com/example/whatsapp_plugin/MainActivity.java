package com.example.whatsapp_plugin;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.provider.MediaStore;


import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;

import com.example.whatsapp_plugin.database.MessageRepositary;
import com.example.whatsapp_plugin.database.WPMessage;
import com.example.whatsapp_plugin.utils.CommonHelper;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "androidBridge";
  public static MethodChannel methodChanel;
  Intent serviceIntent = null;
  MessageRepositary messageRepositary;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    serviceIntent = new Intent(this, NotificationManagerService.class);
    messageRepositary = new MessageRepositary(getApplicationContext());
    startService(serviceIntent);
    methodChanel = new MethodChannel(getFlutterView(), CHANNEL);
    methodChanel.setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method) {
                    case "share":
                        Intent shareIntent = FlutterMessageHandler.getFlutterMessageHandlerInstance().share((String) methodCall.argument("filePath"),getApplicationContext(), (boolean)methodCall.argument("isImage"));
                        startActivity(Intent.createChooser(shareIntent, "Share"));
                        break;
                    case "shareOnWhatsapp":
                        Intent shareOnWhatsappIntent = FlutterMessageHandler.getFlutterMessageHandlerInstance().shareOnWhatsapp((String) methodCall.argument("filePath"),getApplicationContext(), (boolean)methodCall.argument("isImage"));
                        startActivity(Intent.createChooser(shareOnWhatsappIntent,"Share"));
                        break;
                    case "startService":
                        if (serviceIntent == null){
                            serviceIntent = new Intent(getApplicationContext(), NotificationManagerService.class);
                            break;
                        }
                        startService(serviceIntent);
                        break;
                    case "stopService":
                        stopService(serviceIntent);
                        break;
                    case "getAllMessages":
                        List<WPMessage> messageList = messageRepositary.getAllMessages();
                        result.success(CommonHelper.getCommonHelperInstance().parseList(messageList));
                        break;
                    case "deleteAllMsges":
                        messageRepositary.deleteAllMsg();
                        break;
                    case "getNotificationAccess":
                        if(!NotificationManagerCompat.getEnabledListenerPackages(getApplicationContext()).contains(getApplicationContext().getPackageName())) {
                            getApplicationContext().startActivity(new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
                        }
                        break;
                    case "checkNotificationAccess":
                        if (NotificationManagerCompat.getEnabledListenerPackages(getApplicationContext()).contains(getApplicationContext().getPackageName())) {
                            result.success(true);
                        } else {
                            result.success(false);
                        }
                        break;
                }
              }
            }
    );
  }

}
