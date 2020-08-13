package com.ideaboxapps.chatplusstatus;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import androidx.core.content.FileProvider;

import java.io.File;

public class FlutterMessageHandler {
    private static FlutterMessageHandler flutterMessageHandlerInstance;

    private FlutterMessageHandler() {}

    public static FlutterMessageHandler getFlutterMessageHandlerInstance() {
        if (flutterMessageHandlerInstance == null) {
            flutterMessageHandlerInstance = new FlutterMessageHandler();
        }
        return  flutterMessageHandlerInstance;
    }

    public Intent share(String filePath, Context context, boolean isImage) {
        File file = new File(filePath);
        Uri contentUri = FileProvider.getUriForFile(context, "com.ideaboxapps.whatsappPlugin.fileprovider", file);
        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        if (isImage) {
            shareIntent.setType("image/jpg");
        } else {
            shareIntent.setType("video/mp4");
        }
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
        return  shareIntent;
    }

    public Intent shareOnWhatsapp(String filePath, Context context, boolean isImage) {
        File file = new File(filePath);
        Uri contentUri = FileProvider.getUriForFile(context, "com.ideaboxapps.whatsappPlugin.fileprovider", file);
        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        if (isImage) {
            shareIntent.setType("image/jpg");
        } else {
            shareIntent.setType("video/mp4");
        }
        shareIntent.setPackage("com.whatsapp");
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
        return shareIntent;
    }
}
