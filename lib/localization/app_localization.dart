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
    },
  };

  Map<String, String> get localizedValues {
    return _localizedValues[locale.languageCode];
  }

}