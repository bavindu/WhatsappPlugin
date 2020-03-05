package com.ideaboxapps.chatplus.utils;

import android.os.FileObserver;
import android.util.Log;

import androidx.annotation.Nullable;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.channels.FileChannel;

public class StatusGenerateListener extends FileObserver {
    private FileObserver fileObserver;
    private String statusPath;
    private String appPath;
    public File appDir;
    private OutputStream outputStream;
    private  FileChannel inChanel;
    private FileChannel outChanel;

    public StatusGenerateListener(String statusPath, String appPath) {
        super(statusPath,FileObserver.ALL_EVENTS);
        this.statusPath = statusPath;
        this.appPath = appPath;
        appDir = new File(appPath);
        if (!appDir.exists()){
            appDir.mkdir();
        }
    }

    @Override
    public void onEvent(int event, @Nullable String path) {
        if (path != null) {
            Log.i("StatusGenerateListener",path);
            Log.i("Event",String.valueOf(event));
            saveFile(path);
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
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }

}
