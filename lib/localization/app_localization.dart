import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

   static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
      'images': 'Images',
      'chats': 'Chats',
      'videos': 'Videos',
      'share': 'Share',
      'repost': 'Repost',
      'delete_message': 'Delete Messages',
      'privacy_policy' : 'Privacy Policy',
      'no_msg' : 'No Masseges',
      'storage_access_req' : 'Storage Permission Required',
      'storage_permission' : 'Chat Plus need storage permission to show you Whatsapp Status. Chat Plus does not read your personal files and data',
      'notifi_access_req' : 'Notification Permission',
      'notification_permission' : 'Chat Plus need notification permission to read Whatsapp notification.',
      'auto_save' : 'Auto Save Status',
      'faq1Q' : 'Where can I find downloaded status?',
      'faq1A' : 'In Chat Plus floder',
      'faq2Q' : "Why can't I see Photos, Videos and Stickers in chats?",
      'faq2A' : "Chat Plus display WhatsApp messages using Whatsapp notification. In WhatsApp notification there are no videos, photos and stickers",

    },
    'es': {
      'title': 'Hola Mundo',
      'images': 'Imágenes',
      'chats': 'Chats',
      'videos': 'Vídeos',
      'share': 'Compartir',
      'repost': 'Volver a enviar',
      'delete_messages' : 'Eliminar mensajes',
      'privacy_policy' : 'Política de privacidad',
      'no_msg' : 'Ningún mensaje',
      'storage_access_req' : 'Storage Permission Required',
      'storage_permission' : 'Chat Plus need storage permission to show you Video and Image Status. Chat Plus does not read your personal files and data',
      'notifi_access_req' : 'Notification Permission',
      'notification_permission' : 'Chat Plus need notification permission to read Whatsapp notification',
      'faq1Q' : 'Where can I find downloaded status?',
      'auto_save' : 'Auto Save Status',
      'faq1A' : 'In Chat Plus floder',
      'faq2Q' : "Why can't I see Photos, Videos and Stickers in chats?",
      'faq2A' : "Chat Plus display WhatsApp messages using Whatsapp notification. In WhatsApp notification there are no videos, photos and stickers",
    },
  };

  Map<String, String> get localizedValues {
    return _localizedValues[locale.languageCode];
  }

}