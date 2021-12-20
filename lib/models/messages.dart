import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  Messages({
    required this.messageID,
    required this.message,
    required this.date,
    required this.time,
    required this.timestamp,
    required this.sendBy,
  });

  final String messageID;
  final String message;
  final String date;
  final String time;
  final String timestamp;
  final String sendBy;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': messageID,
      'message': message,
      'date': date,
      'time': time,
      'timestamp': timestamp,
      'send_by': sendBy,
    };
  }

  // ignore: sort_constructors_first
  factory Messages.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Messages(
      messageID: doc.data()!['message_id'] ?? '',
      message: doc.data()!['message'] ?? '',
      date: doc.data()!['date'] ?? '',
      time: doc.data()!['time'] ?? '',
      timestamp: doc.data()!['timestamp'] ?? '',
      sendBy: doc.data()!['send_by'] ?? '',
    );
  }
}
