import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class ChatHead {
  String _sender;
  String _text;
  String _groupName;
  DateTime _date;
  bool _isGroupMsg;
  String _diplayDate;
  DateTime now = DateTime.now();
  CommonHelperService commonHelperService = locator<CommonHelperService>();


  ChatHead (String sender, String text, String groupName, DateTime date,  bool isGroupMsg) {
    this._sender = sender;
    this._text = text.replaceAll("\n", " ");
    this._groupName = groupName;
    this._date = date;
    this.isGroupMsg = isGroupMsg;
    this._diplayDate = commonHelperService.setDisplayDate(date);
  }


  bool get isGroupMsg => _isGroupMsg;

  set isGroupMsg(bool value) {
    _isGroupMsg = value;
  }

  String get sender => _sender;

  set sender(String value) {
    _sender = value;
  }

  String get text => _text;

  set text(String value) {
    _text = value.replaceAll("\n", " ");
  }

  String get groupName => _groupName;

  set groupName(String value) {
    _groupName = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
    this._diplayDate = commonHelperService.setDisplayDate(value);
  }

  String get diplayDate => _diplayDate;

}