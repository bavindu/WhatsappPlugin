package com.example.whatsapp_plugin.database;

import android.app.Application;
import android.content.Context;
import android.os.AsyncTask;

import java.util.List;
import java.util.concurrent.ExecutionException;

public class MessageRepositary {
    private MessageDao messageDao;

    public MessageRepositary(Context context) {
        MessageDatabase messageDatabase = MessageDatabase.getInstance(context);
        messageDao = messageDatabase.messageDao();
    }

    public void insertMessage(WPMessage wpMessage) {
        new InsertMessageAsyncTask(messageDao).execute(wpMessage);
    }

    public List<WPMessage> getAllMessages() {
        List<WPMessage> wpMessageList =  null;
        try {
            wpMessageList =  new  GetAllMessageAsyncTask(messageDao).execute().get();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return  wpMessageList;
    }


    private static class InsertMessageAsyncTask extends AsyncTask<WPMessage, Void, Void> {
        private MessageDao messageDao;

        private InsertMessageAsyncTask(MessageDao messageDao) {
            this.messageDao = messageDao;
        }
        @Override
        protected Void doInBackground(WPMessage... wpMessages) {
            messageDao.insert(wpMessages[0]);
            return null;
        }
    }

    private static class GetAllMessageAsyncTask extends  AsyncTask<Void, Void, List<WPMessage>> {
        private MessageDao messageDao;

        private GetAllMessageAsyncTask(MessageDao messageDao) {
            this.messageDao = messageDao;
        }

        @Override
        protected List<WPMessage> doInBackground(Void... voids) {
            return messageDao.getAllWPMessage();
        }
    }
}
