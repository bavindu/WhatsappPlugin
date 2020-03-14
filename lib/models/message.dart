import 'dart:convert';

class Message {
  final String groupName;
  final String id;
  final bool isGroupMessage;
  final String text;
  final String sender;

  Message(
      this.groupName,
      this.id,
      this.isGroupMessage,
      this.text,
      this.sender,
      );
  Message.fromJson(Map<String,dynamic> json)
    :groupName = json['groupName'],
     id = json['id'],
     isGroupMessage = json['isGroupMessage'],
     text = json['text'],
     sender = json['sender'];

  Map<String,dynamic> toJson() =>
      {
        'groupName' : groupName,
        'id' : id,
        'isGroupMessage' : isGroupMessage,
        'text' : text,
      };
}