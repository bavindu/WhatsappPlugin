import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:whatsapp_plugin/models/chat_bubble.dart';

class ChatBubbleContainer extends StatelessWidget {
  final ChatBubble chatBubble;
  ChatBubbleContainer(this.chatBubble);

  String _getDisplayDate(DateTime dateTime) {
    String displayDate;
    var minute = dateTime.minute.toString();
    var hour = dateTime.hour.toString();
    if (minute.length == 1) {
      minute = '0' + minute;
    }
    if (hour.length == 1) {
      hour = '0' + hour;
    }
    displayDate = hour + '.' + minute;
    return displayDate;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0)),
          color: Colors.white),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(
          left: 10.0, top: 10.0, bottom: 10.0, right: 60.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  chatBubble.isGroupMsg? chatBubble.sender : '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text(_getDisplayDate(chatBubble.date)),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  chatBubble.text,
                  softWrap: true,
                ),
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ],
          )
        ],
      )
    );
  }
}
