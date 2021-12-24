import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/widgets/custom_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventAPI {
  static const String _collection = 'events';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> addEvent(Event event) async {
    event.coverimage = await uploadImage(
        File(event.coverimage).readAsBytesSync(), getRandomString(5));
    await _instance
        .collection(_collection)
        .doc(event.id)
        .set(event.toJson())
        .catchError((Object e) {
      CustomToast.errorToast(message: e.toString());
      // ignore: invalid_return_type_for_catch_error
      return false;
    });
    return true;
  }

  Future<String> uploadImage(Uint8List? imageBytes, String uid) async {
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child('event_images/$uid')
        .putData(imageBytes!);
    String url = (await snapshot.ref.getDownloadURL()).toString();
    return url;
  }

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<List<Event>> geteventsbyuserid({required String userid}) async {
    List<Event> digilogs = <Event>[];
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(_collection)
        .where('hostuid', isEqualTo: userid)
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>?>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>?> doc in docs) {
      if (doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Event digilog = Event.fromJson(data);
        digilogs.add(digilog);
      }
    }
    return digilogs;
  }
}
