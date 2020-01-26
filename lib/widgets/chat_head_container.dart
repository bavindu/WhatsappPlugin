import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/models/chat_head.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class ChatHeadContainer extends StatelessWidget {
  final ChatHead chatHead;
  CommonHelperService commonHelperService = locator<CommonHelperService>();
  ChatHeadContainer(this.chatHead);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  backgroundColor: commonHelperService.getRandomColor(),
                  child: Text(
                      chatHead.isGroupMsg
                      ? chatHead.groupName[0]
                      : chatHead.sender[0],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    chatHead.isGroupMsg ? chatHead.groupName : chatHead.sender,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Container(
                    child: Text(
                      chatHead.isGroupMsg ? chatHead.sender + ' : ' + chatHead.text : chatHead.text,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                  )
                ],
              ),
            ],
          ),
          Text(chatHead.diplayDate)
        ],
      ),
    );
  }
}
