package com.ideaboxapps.chatplusstatus;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;


import androidx.core.app.NotificationManagerCompat;

import com.ideaboxapps.chatplusstatus.database.MessageRepositary;
import com.ideaboxapps.chatplusstatus.database.WPMessage;
import com.ideaboxapps.chatplusstatus.utils.CommonHelper;
import com.ideaboxapps.chatplusstatus.utils.StatusGenerateListener;

import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "androidBridge";
  public static  final String CHANNEL_ID = "channel1";
  public static MethodChannel methodChanel;
  Intent serviceIntent = null;
  Intent statusServiceIntent = null;
  MessageRepositary messageRepositary;
  StatusGenerateListener statusGenerateListener;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    this.createNotificationChanel();
    serviceIntent = new Intent(this, NotificationManagerService.class);
    statusServiceIntent = new Intent(MainActivity.this, StatusAutoSaveService.class);
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
                        startActivity(Intent.createChooser(shareIntent, "Share Via"));
                        break;
                    case "shareOnWhatsapp":
                        Intent shareOnWhatsappIntent = FlutterMessageHandler.getFlutterMessageHandlerInstance().shareOnWhatsapp(
                                (String) methodCall.argument("filePath"),
                                getApplicationContext(),
                                (boolean)methodCall.argument("isImage")
                        );
                        startActivity(Intent.createChooser(shareOnWhatsappIntent,"Share"));
                        break;
                    case "shareOnWhatsappMulti":
                        Intent shareOnWhatsappMultiIntent = FlutterMessageHandler.getFlutterMessageHandlerInstance().shareOnWhatsappMulti(
                                (String) methodCall.argument("directory"),
                                (String) methodCall.argument("fileName"),
                                (Integer) methodCall.argument("numOfParts"),
                                getApplicationContext()
                                );
                        startActivity(Intent.createChooser(shareOnWhatsappMultiIntent,"Share"));
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
                        List<String> parsedList = CommonHelper.getCommonHelperInstance().parseList(messageList);
                        result.success(parsedList);
                        break;
                    case "deleteAllMsges":
                        messageRepositary.deleteAllMsg();
                        break;
                    case "stopListenToStatusGen":
                        stopService(new Intent(MainActivity.this,StatusAutoSaveService.class));
                        break;
                    case "startListenToStatusGen":
                        String statusPath = methodCall.argument("filePath");
                        String appPath = methodCall.argument("appPath");
                        statusServiceIntent.putExtra("statusPath", statusPath);
                        statusServiceIntent.putExtra("appPath", appPath);
                        startService(statusServiceIntent);
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
                    case "checkWhatsappInstalled":
                        boolean isWhatsappInstalled;
                        PackageManager packageManager = getPackageManager();
                        try {
                            packageManager.getPackageInfo("com.whatsapp",PackageManager.GET_ACTIVITIES);
                            isWhatsappInstalled = true;
                        } catch (PackageManager.NameNotFoundException e) {
                            e.printStackTrace();
                            isWhatsappInstalled = false;
                        }
                        result.success(isWhatsappInstalled);
                        break;
                    case "toastMessage":
                        String msg = methodCall.arguments();
                        Toast toast=Toast.makeText(getApplicationContext(),msg,Toast.LENGTH_LONG);
                        toast.show();
                        break;
                    case "rateUs":
                        try {
                            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + getPackageName())));
                        } catch (ActivityNotFoundException e) {
                            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://play.google.com/store/apps/details?id=" + getPackageName())));
                        }
                        break;
                    case "invite":
                        Intent inviteIntent = new Intent();
                        StringBuilder inviteMessage = new StringBuilder();
                        inviteMessage.append("Hey, Download this awesome app!");
                        inviteMessage.append("\n");
                        inviteMessage.append("https://play.google.com/store/apps/details?id="+getPackageName());
                        inviteIntent.setAction(Intent.ACTION_SEND);
                        inviteIntent.putExtra(Intent.EXTRA_TEXT, inviteMessage.toString());
                        inviteIntent.setType("text/plain");
                        startActivity(Intent.createChooser(inviteIntent, "Share Via"));
                        break;
                    case "mediaScan":
                        String filePath = methodCall.argument("filePath");
                        try {
                            MediaScannerConnection.scanFile(MainActivity.this, new String[] {filePath},new String[] {"image/jpg", "video/mp4"},new MediaScannerConnection.OnScanCompletedListener() {

                                public void onScanCompleted(String path, Uri uri) {
                                    Log.i("TAG", "Finished scanning " + path);
                                }
                            });
                        } catch (Exception e){
                            Log.e("MediaScan", e.toString());
                        }
                        break;
                }
              }
            }
    );
  }

  public void createNotificationChanel() {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          CharSequence name = "Channel 1";
          String description = "this is channel 1";
          int importance = NotificationManager.IMPORTANCE_HIGH;
          NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
          channel.setDescription(description);
          NotificationManager notificationManager = getSystemService(NotificationManager.class);
          notificationManager.createNotificationChannel(channel);
      }
  }

}
