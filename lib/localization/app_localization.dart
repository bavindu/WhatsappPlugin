import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

   static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'images' : 'Images',
      'chats' : 'Chats',
      'videos' : 'Videos',
      'share' : 'Share',
      'repost' : 'Repost',
      'delete_message' : 'Delete Messages',
      'privacy_policy' : 'Privacy Policy',
      'no_msg' : 'No Masseges',
      'storage_access_req' : 'Storage Permission Required',
      'storage_permission' : 'Chat Plus need storage permission to show you Whatsapp Status',
      'notifi_access_req' : 'Notification Permission',
      'notification_permission' : 'Chat Plus need notification permission to read Whatsapp notification.Enable this for Chat Plus in Notification Access Window',
      'auto_save' : 'Auto Save Status',
      'rate_us' : 'Rate Us',
      'whatsapp_notfound' : 'WhatsApp not installed!',
      'del_msg_dialog' : 'Do you want to delete message in Chat Plus',
      'yes': 'Yes',
      'no' : 'No',
      'faq1Q' : 'Where can I find saved status?',
      'faq1A' : 'In the Gallery or Chat Plus floder',
      'faq2Q' : "Why can't I see Photos, Videos and Stickers in chats?",
      'faq2A' : "Chat Plus displays WhatsApp messages using WhatsApp notification.In WhatsApp notifications,there are no videos,photos and stickers",
      'faq3Q' : "What 'Auto Save Status' option does?",
      'faq3A' : "It svae WhatsApp status automatically in to your storage when you view status in WhatsApp. You can disable this option",
      'faq4Q' : "Why I don't recieved WhatsApp message to Chat Plus?",
      'faq4A' : "Please make sure you receive WhatsApp notification. You can enable this in WhatsApp settings",
      'faq5Q' : "How to save multiple status?",
      'faq5A' : "Just long pressed on a status to activate multi select mode. The you can select statuses one by one or select. After selecting press save icon"
    },

    'es': {
      'images' : 'Imágenes',
      'chats' : 'Chats',
      'videos' : 'Vídeos',
      'share' : 'Compartir',
      'repost' : 'Volver a enviar',
      'delete_messages' : 'Eliminar mensajes',
      'privacy_policy' : 'Política de privacidad',
      'no_msg' : 'sin mensaje',
      'storage_access_req' : 'Se requiere permiso de almacenamiento',
      'storage_permission' : 'Chat Plus need storage permission to show you Video and Image Status.',
      'notifi_access_req' : 'Notification Permission',
      'notification_permission' : 'Chat Plus need notification permission to read Whatsapp notification',
      'rate_us' : 'Rate Us',
      'whatsapp_notfound' : 'WhatsApp not installed!',
      'yes': 'Si',
      'no' : 'No',
      'del_msg_dialog' : 'Du desea eliminar el mensaje en Chat Plus',
      'faq1Q' : 'Where can I find saved status?',
      'auto_save' : 'Auto Save Status',
      'faq1A' : 'In the Gallery or Chat Plus floder',
      'faq2Q' : "Why can't I see Photos, Videos and Stickers in chats?",
      'faq2A' : "Chat Plus displays WhatsApp messages using WhatsApp notification. In WhatsApp notifications, there are no videos, photos and stickers",
      'faq3Q' : "What 'Auto Save Status' option does?",
      'faq3A' : "It svae WhatsApp status automatically in to your storage when you view status in WhatsApp. You can disable this option",
      'faq4Q' : "Why I don't recieved WhatsApp message to Chat Plus?",
      'faq4A' : "Please make sure you receive WhatsApp notification. You can enable this in WhatsApp settings",
      'faq5Q' : "How to save multiple status?",
      'faq5A' : "Just long click on a status to activate multi select mode. The you can select statuses one by one or select. After selecting press save icon"
    },
  };

  Map<String, String> get localizedValues {
    return _localizedValues[locale.languageCode];
  }

}