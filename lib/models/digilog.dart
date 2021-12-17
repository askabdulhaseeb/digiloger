import 'package:hive/hive.dart';
part 'digilog.g.dart';

@HiveType(typeId: 1)
class Digilog extends HiveObject {
  Digilog({
    required this.useruid,
    required this.location,
    required this.postedTime,
    required this.title,
  });

  Digilog.fromJson(Map<String, dynamic> json) {
    useruid = json['useruid'];
    location = (json['location'] != null
        ? Location.fromJson(json['location'])
        : null)!;
    postedTime = json['postedTime'];
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((Map<String, dynamic> v) {
        experiences.add(Experiences.fromJson(v));
      });
    }
    title = json['title'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((Map<String, dynamic> v) {
        comments.add(Comments.fromJson(v));
      });
    }
    likes = json['likes'];
  }
  @HiveField(0)
  String useruid = "";
  @HiveField(1)
  late Location location;
  @HiveField(2)
  String postedTime = "";
  @HiveField(3)
  List<Experiences> experiences = <Experiences>[];
  @HiveField(4)
  String title = "";
  @HiveField(5)
  List<Comments> comments = <Comments>[];
  @HiveField(6)
  int likes = 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useruid'] = useruid;
    data['location'] = location.toJson();
    data['postedTime'] = postedTime;
    if (data['experiences'] != null) {
      data['experiences'] =
          experiences.map((Experiences v) => v.toJson()).toList();
    }
    data['title'] = title;
    if (data['comments'] != null) {
      data['comments'] = comments.map((Comments v) => v.toJson()).toList();
    }
    data['likes'] = likes;
    return data;
  }
}

@HiveType(typeId: 2)
class Location {
  Location({required this.lat, required this.long});
  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }
  @HiveField(0)
  double lat = 0.00;
  @HiveField(1)
  double long = 0.00;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

@HiveType(typeId: 3)
class Experiences {
  Experiences(
      {required this.mediaUrl,
      required this.mediatype,
      required this.description});
  Experiences.fromJson(Map<String, dynamic> json) {
    mediaUrl = json['mediaUrl'];
    mediatype = json['mediatype'];
    description = json['description'];
  }
  @HiveField(0)
  String mediaUrl = "";
  @HiveField(1)
  String mediatype = "";
  @HiveField(2)
  String description = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaUrl'] = mediaUrl;
    data['mediatype'] = mediatype;
    data['description'] = description;
    return data;
  }
}

@HiveType(typeId: 4)
class Comments {
  Comments({required this.uid, required this.message, required this.likes});
  Comments.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    message = json['message'];
    likes = json['likes'];
  }
  @HiveField(0)
  String uid = "";
  @HiveField(1)
  String message = "";
  @HiveField(2)
  int likes = 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['message'] = message;
    data['likes'] = likes;
    return data;
  }
}
