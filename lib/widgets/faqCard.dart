import 'package:flutter/material.dart';

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  const FAQCard(this.question, this.answer);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: Colors.white70,
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(answer,style: TextStyle(fontSize: 17.0),textAlign: TextAlign.justify,),
            )
          ],
        ),
      )),
    );
  }
}
