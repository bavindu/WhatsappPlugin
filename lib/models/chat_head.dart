class ChatHead {
  String _sender;
  String _text;
  String _groupName;
  DateTime _date;
  bool _isGroupMsg;

  ChatHead (String sender, String text, String groupName, DateTime date,  bool isGroupMsg) {
    this._sender = sender;
    this._text = text;
    this._groupName = groupName;
    this._date = date;
    this.isGroupMsg = isGroupMsg;
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
    _text = value;
  }

  String get groupName => _groupName;

  set groupName(String value) {
    _groupName = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }
}