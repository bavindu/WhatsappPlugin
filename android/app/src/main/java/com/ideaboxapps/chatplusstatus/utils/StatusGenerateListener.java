package com.ideaboxapps.chatplusstatus.utils;

import android.content.Context;
import android.os.FileObserver;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.ideaboxapps.chatplusstatus.MainActivity;
import com.ideaboxapps.chatplusstatus.R;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.channels.FileChannel;

public class StatusGenerateListener extends FileObserver {
    private String statusPath;
    public File appDir;
    private OutputStream outputStream;
    private  FileChannel inChanel;
    private FileChannel outChanel;
    Context context;
    private static  StatusGenerateListener statusGenerateListenerInstance;

    private StatusGenerateListener(String statusPath, String appPath, Context context) {
        super(statusPath,FileObserver.MOVED_TO);
        this.statusPath = statusPath;
        this.context = context;
        appDir = new File(appPath);
        if (!appDir.exists()){
            appDir.mkdir();
        }
        Log.i("StatusGenerateListener","Object created");
    }

    @Override
    public void onEvent(int event, @Nullable String path) {
        if (path != null) {
            if (event == FileObserver.MOVED_TO) {
                Log.i("StatusGenerateListener",path);
                Log.i("Event",String.valueOf(event));
                saveFile(path);
            }
        }
    }



    private void saveFile(String path) {
        File source = new File(this.statusPath+File.separator+path);
        File status = new File(this.appDir+File.separator+path);

        try {
            inChanel = new FileInputStream(source).getChannel();
            outChanel = new FileOutputStream(status).getChannel();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        try {
            inChanel.transferTo(0,inChanel.size(),outChanel);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (inChanel != null) {
                    inChanel.close();
                }
                if (outChanel != null) {
                    outChanel.close();
                }
                this.createNotification();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }



    }

    public static synchronized StatusGenerateListener getStatusGenerateListener(String statusPath, String appPath, Context context) {
        if (statusGenerateListenerInstance == null) {
            statusGenerateListenerInstance = new StatusGenerateListener(statusPath,appPath,context);
        }
         return  statusGenerateListenerInstance;
    }


    @Override
    protected void finalize() {
        super.finalize();
        Log.i("StatusGenerateListener","Garbage Collected");
    }

    public void  createNotification() {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, MainActivity.CHANNEL_ID)
                .setSmallIcon(R.drawable.notification_icon)
                .setContentTitle("Chat Plus")
                .setContentText("Status saved")
                .setPriority(NotificationCompat.PRIORITY_HIGH);
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
        notificationManagerCompat.notify(1,builder.build());
    }


}
