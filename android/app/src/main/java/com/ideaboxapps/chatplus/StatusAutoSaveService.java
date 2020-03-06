package com.ideaboxapps.chatplus;

import android.app.IntentService;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.ideaboxapps.chatplus.utils.StatusGenerateListener;

public class StatusAutoSaveService extends Service {
    private static final String STATUS_PATH = "statusPath";
    private static final String APP_PATH = "appPath";
    private static StatusGenerateListener statusGenerateListener;

    public StatusAutoSaveService() {
        super();
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Context context = getApplicationContext();
        String statusPath = intent.getStringExtra(STATUS_PATH);
        String appPath = intent.getStringExtra(APP_PATH);
        statusGenerateListener = StatusGenerateListener.getStatusGenerateListener(statusPath,appPath,context);
        statusGenerateListener.startWatching();
        Log.i("StatusAutoSaveService","Service Started");
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        statusGenerateListener.stopWatching();
        Log.i("StatusAutoSaveService","Service destroyed");
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

}
