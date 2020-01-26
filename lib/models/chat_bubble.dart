class ChatBubble {
  final String text;
  final DateTime date;
  final String sender;
  final bool isGroupMsg;
  ChatBubble(this.text, this.sender, this.date, this.isGroupMsg);
}