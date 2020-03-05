import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/widgets/faqCard.dart';

class FAQView extends StatefulWidget {
  @override
  _FAQViewState createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('FAQ',style: TextStyle(color: Colors.white),),
        backgroundColor: PRIMARY_COLOR,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, '/');
            }),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            FAQCard(AppLocalizations.of(context).localizedValues['faq1Q'],AppLocalizations.of(context).localizedValues['faq1A']),
            FAQCard(AppLocalizations.of(context).localizedValues['faq2Q'],AppLocalizations.of(context).localizedValues['faq2A'])
          ],
        ),
      ),
    );
  }
}
