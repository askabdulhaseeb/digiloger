import 'package:digiloger/models/digilog.dart';
import 'package:hive/hive.dart';

class DigilogAPI {
  static const String _boxname = 'digilog_box';

  Future<int> adddigilog(Digilog digilog) async {
    final Box<Digilog> box = await Hive.openBox(_boxname);
    int id = await box.add(digilog);
    box.close();
    return id;
  }

  Future<List<Digilog>> getalldigilog() async {
    final Box<Digilog> box = await Hive.openBox(_boxname);
    List<Digilog> digilog = <Digilog>[];
    for (int i = 0; i < box.length; i++) {
      digilog.add(box.getAt(i)!);
    }
    box.close();
    return digilog;
  }

//TODO:Check these please
  Future<Digilog> getdigilog(int index) async {
    final Box<Digilog> box = await Hive.openBox(_boxname);
    Digilog digi = box.getAt(index)!;
    Hive.close();
    return digi;
  }

  Future<void> addexperience(int index, Experiences exp) async {
    Digilog oldDigi = await DigilogAPI().getdigilog(index);
    final Box<Digilog> box1 = await Hive.openBox(_boxname);
    oldDigi.experiences.add(exp);
    if (box1.isOpen) {
      await box1.putAt(index, oldDigi);
    } else {
      final Box<Digilog> box1 = await Hive.openBox(_boxname);
      await box1.putAt(index, oldDigi);
    }
    Hive.close();
  }
}
