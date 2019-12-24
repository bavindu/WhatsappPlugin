package com.example.whatsapp_plugin;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.provider.MediaStore;


import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "androidBridge";
  public static MethodChannel methodChanel;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    methodChanel = new MethodChannel(getFlutterView(), CHANNEL);
    if(!NotificationManagerCompat.getEnabledListenerPackages(getApplicationContext()).contains(getApplicationContext().getPackageName())) {
        getApplicationContext().startActivity(new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
    }
    methodChanel.setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method) {
                  case "share":
                    Intent shareIntent = FlutterMessageHandler.getFlutterMessageHandlerInstance().share((String) methodCall.argument("filePath"),getApplicationContext(), (boolean)methodCall.argument("isImage"));
                    startActivity(Intent.createChooser(shareIntent, "Share Image"));
                    break;
                    case "shareOnWhatsapp":
                        Intent shareOnWhatsappIntent = FlutterMessageHandler.getFlutterMessageHandlerInstance().shareOnWhatsapp((String) methodCall.argument("filePath"),getApplicationContext(), (boolean)methodCall.argument("isImage"));
                        startActivity(Intent.createChooser(shareOnWhatsappIntent,"share"));
                }
              }
            }
    );
  }

}
