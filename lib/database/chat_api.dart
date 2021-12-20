import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiloger/services/user_local_data.dart';

class ChatAPI {
  static const String _colloction = 'chats';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  static String getChatID({required String othersUID}) {
    bool _isGreaterThen = UserLocalData.getUID.compareTo(othersUID) as bool;
    if (_isGreaterThen) {
      return '${UserLocalData.getUID}-chats-$othersUID';
    } else {
      return '$othersUID-chats-${UserLocalData.getUID}';
    }
  }
}
