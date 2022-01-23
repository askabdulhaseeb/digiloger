import 'package:uuid/uuid.dart';

import 'digilog.dart';

class Event {
  Event(
      {required this.name,
      required this.description,
      required this.hostuid,
      required this.location,
      required this.coverimage}) {
    attendeeslist = <String>[];
    intrestedlist = <String>[];
    reviews = <Comments>[];
    Uuid uuid = const Uuid();
    id = uuid.v4();
  }

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    hostuid = json['hostuid'];
    attendeeslist = json['attendeeslist'].cast<String>();
    intrestedlist = json['intrestedlist'].cast<String>();
    location = Location.fromJson(json['location']);
    coverimage = json['coverimage'];
    if (json['comments'] != null) {
      reviews = <Comments>[];
      json['comments'].forEach((v) {
        reviews.add(Comments.fromJson(v));
      });
    }
  }
  late String id;
  late String name;
  late String description;
  late String hostuid;
  late List<String> attendeeslist;
  late List<String> intrestedlist;
  late Location location;
  late String coverimage;
  List<Comments> reviews = <Comments>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['hostuid'] = hostuid;
    data['attendeeslist'] = attendeeslist;
    data['intrestedlist'] = intrestedlist;
    data['location'] = location.toJson();
    data['coverimage'] = coverimage;
    data['reviews'] = reviews.map((Comments v) => v.toJson()).toList();
    return data;
  }
}
