class ChatHead {
  String _sender;
  String _text;
  String _groupName;
  DateTime _date;
  bool _isGroupMsg;
  String _diplayDate;
  DateTime now = DateTime.now();


  ChatHead (String sender, String text, String groupName, DateTime date,  bool isGroupMsg) {
    this._sender = sender;
    this._text = text.replaceAll("\n", " ");
    this._groupName = groupName;
    this._date = date;
    this.isGroupMsg = isGroupMsg;
    this._setDisplayDate(date);
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
    this._setDisplayDate(value);
  }

  String get diplayDate => _diplayDate;

  void _setDisplayDate(DateTime date) {
    if (DateTime(now.year, now.month, now.day) == DateTime(date.year, date.month, date.day)) {
      this._diplayDate = this.date.hour.toString() + '.' + this.date.minute.toString();
    } else if (DateTime(now.year, now.month, now.day-1) == DateTime(date.year, date.month, date.day)) {
      this._diplayDate = 'YesterDay';
    } else {
      this._diplayDate = date.year.toString() + '/' + date.month.toString() + '/' + date.day.toString();
    }
  }
}