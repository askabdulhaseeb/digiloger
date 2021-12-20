import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  Messages({
    required this.messageID,
    required this.message,
    required this.timestamp,
    required this.sendBy,
  });

  final String messageID;
  final String message;
  final String timestamp;
  final String sendBy;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': messageID,
      'message': message,
      'timestamp': timestamp,
      'send_by': sendBy,
    };
  }

  // ignore: sort_constructors_first
  factory Messages.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Messages(
      messageID: doc.data()!['message_id'] ?? '',
      message: doc.data()!['message'] ?? '',
      timestamp: doc.data()!['timestamp'] ?? '',
      sendBy: doc.data()!['send_by'] ?? '',
    );
  }
}
