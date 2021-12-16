class Digilog {
  Digilog(
      {required this.useruid,
      required this.location,
      required this.postedTime,
      required this.experiences,
      required this.title,
      required this.comments,
      required this.likes});

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
  String useruid = "";
  late Location location;
  String postedTime = "";
  List<Experiences> experiences = <Experiences>[];
  String title = "";
  List<Comments> comments = <Comments>[];
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

class Location {
  Location({required this.lat, required this.long});
  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }
  double lat = 0.00;
  double long = 0.00;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

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
  String mediaUrl = "";
  String mediatype = "";
  String description = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaUrl'] = mediaUrl;
    data['mediatype'] = mediatype;
    data['description'] = description;
    return data;
  }
}

class Comments {
  Comments({required this.uid, required this.message, required this.likes});
  Comments.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    message = json['message'];
    likes = json['likes'];
  }
  String uid = "";
  String message = "";
  int likes = 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['message'] = message;
    data['likes'] = likes;
    return data;
  }
}
