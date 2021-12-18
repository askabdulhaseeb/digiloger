import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    return true;
  }

  Future<void> savedigilog(Digilog digilog) async {
    _digilogBox.put(digilog.digilogid, digilog);
  }

  Future<List<Digilog>> getalldigilog() async {
    List<Digilog> digilog = <Digilog>[];
    for (int i = 0; i < _digilogBox.length; i++) {
      digilog.add(_digilogBox.getAt(i)!);
    }

    return digilog;
  }

//TODO:Check these please
  Future<Digilog> getdigilog(int index) async {
    Digilog digi = _digilogBox.getAt(index)!;
    return digi;
  }

  Future<void> addexperience(int index, Experiences exp) async {
    Digilog oldDigi = await getdigilog(index);
    oldDigi.experiences.add(exp);
    oldDigi.save();
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

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
