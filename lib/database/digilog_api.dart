import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/widgets/custom_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DigilogAPI {
  DigilogAPI() {
    Future.wait([_openBox()]);
  }
  static const String _boxname = 'digilog';
  static const String _collection = 'digilogs';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  Box<Digilog> _digilogBox = Hive.box(_boxname);

  Future<void> _openBox() async {
    if (_digilogBox.isOpen) {
      return;
    } else {
      Directory dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      _digilogBox = await Hive.openBox(_boxname);
      return;
    }
  }

  Future<bool> postDigilog(Digilog digilog) async {
    await uploaddatatofirebase(digilog);
    await deletedigilogfromhive(digilog);
    await _instance
        .collection(_collection)
        .doc(digilog.digilogid)
        .set(digilog.toJson())
        .catchError((Object e) {
      CustomToast.errorToast(message: e.toString());
      // ignore: invalid_return_type_for_catch_error
      return false;
    });
    await UserAPI().addpostcount(digilog.digilogid);
    return true;
  }

  Future<void> savedigilog(Digilog digilog) async {
    _digilogBox.put(digilog.digilogid, digilog);
  }

  Future<List<Digilog>> getalllocaldigilog() async {
    List<Digilog> digilog = <Digilog>[];
    for (int i = 0; i < _digilogBox.length; i++) {
      digilog.add(_digilogBox.getAt(i)!);
    }

    return digilog;
  }

  Future<List<Digilog>> getallfirebasedigilogsbyuid(String uid) async {
    List<Digilog> digilogs = <Digilog>[];
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(_collection)
        .where('useruid', isEqualTo: uid)
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>?>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>?> doc in docs) {
      if (doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Digilog digilog = Digilog.fromJson(data);
        digilogs.add(digilog);
      }
    }
    return digilogs;
  }

  Future<List<Digilog>> getallfirebasedigilogs() async {
    List<Digilog> digilogs = <Digilog>[];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(_collection).get();

    List<QueryDocumentSnapshot<Map<String, dynamic>?>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>?> doc in docs) {
      if (doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Digilog digilog = Digilog.fromJson(data);
        digilogs.add(digilog);
      }
    }
    return digilogs;
  }

  Future<List<Digilog>> getallfirebasedigilogsbytitle(String title) async {
    List<Digilog> digilogs = <Digilog>[];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(_collection).get();

    List<QueryDocumentSnapshot<Map<String, dynamic>?>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>?> doc in docs) {
      if (doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Digilog digilog = Digilog.fromJson(data);
        if (digilog.title.contains(title)) {
          digilogs.add(digilog);
        }
      }
    }
    return digilogs;
  }

  Future<List<Digilog>> getallfirebasedigilogsbylocation(
      String location) async {
    List<Digilog> digilogs = <Digilog>[];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(_collection).get();

    List<QueryDocumentSnapshot<Map<String, dynamic>?>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>?> doc in docs) {
      if (doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Digilog digilog = Digilog.fromJson(data);
        if (digilog.location.maintext.contains(location)) {
          digilogs.add(digilog);
        }
      }
    }
    return digilogs;
  }

  Future<List<Digilog>> getallfirebasedigilogsbylistuid(
      List<String> uids) async {
    List<Digilog> digilogs = <Digilog>[];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(_collection)
        .where('useruid', whereIn: uids)
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>?>> docs = snapshot.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>?> doc in docs) {
      if (doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Digilog digilog = Digilog.fromJson(data);
        digilogs.add(digilog);
      }
    }

    return digilogs;
  }

  Future<void> deletedigilogfromhive(Digilog id) async {
    _digilogBox.delete(id.digilogid);
  }

  Future<void> uploaddatatofirebase(Digilog digilog) async {
    for (int i = 0; i < digilog.experiences.length; i++) {
      File file = File(digilog.experiences[i].mediaUrl);
      String id = getRandomString(15);
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('digilog_images/$id/$i')
          .putData(file.readAsBytesSync());
      String url = (await snapshot.ref.getDownloadURL()).toString();
      await file.delete();
      digilog.experiences[i].mediaUrl = url;
    }
    return;
  }

  Future<void> updateComment(
      {required String pid, required List<Comments> comments}) async {
    await _instance.collection(_collection).doc(pid).update({
      'comments': comments.map((Comments e) => e.toJson()).toList(),
    });
  }

  Future<void> updateLikes(
      {required String pid, required List<String> likes}) async {
    await _instance.collection(_collection).doc(pid).update({
      'likes': likes,
    });
  }

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
