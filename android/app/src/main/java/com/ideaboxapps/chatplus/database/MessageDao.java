package com.ideaboxapps.chatplus.database;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface MessageDao {

    @Insert
    void insert(WPMessage wpMessage);

    @Query("SELECT * FROM wpmessage")
    List<WPMessage> getAllWPMessage();

    @Query("SELECT id, sender,text , groupName, isGroupMessage FROM wpmessage WHERE id = :id LIMIT 1")
    WPMessage exist(String id);

    @Query("DELETE FROM wpmessage")
    void deleteAllMsg();
}
