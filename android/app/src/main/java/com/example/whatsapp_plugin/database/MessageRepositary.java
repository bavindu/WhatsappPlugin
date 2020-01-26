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

    public boolean checkAlreadyExists(String id) {
        WPMessage wpMessage = null;
        try {
            wpMessage = new CheckAlreadyExists(messageDao).execute(id).get();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        if (wpMessage != null) {
            return  true;
        } else {
            return  false;
        }

    }

    public void deleteAllMsg(){
        new DeleteAllMsgMessageAsyncTask(messageDao).execute();
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

    private static class CheckAlreadyExists extends  AsyncTask<String, Void, WPMessage> {
        private MessageDao messageDao;

        private CheckAlreadyExists(MessageDao messageDao) {
            this.messageDao = messageDao;
        }

        @Override
        protected WPMessage doInBackground(String... strings) {
            return  messageDao.exist(strings[0]);
        }
    }

    private static class DeleteAllMsgMessageAsyncTask extends AsyncTask<Void, Void, Void> {
        private MessageDao messageDao;

        private DeleteAllMsgMessageAsyncTask(MessageDao messageDao) {
            this.messageDao = messageDao;
        }

        @Override
        protected Void doInBackground(Void... voids) {
            messageDao.deleteAllMsg();
            return null;
        }
    }
}
