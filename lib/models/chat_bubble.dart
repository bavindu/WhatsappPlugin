class ChatBubble {
  final String text;
  final DateTime date;
  final String sender;
  final bool isGroupMsg;
  String displayDate;
  ChatBubble(this.text, this.sender, this.date, this.isGroupMsg);
}