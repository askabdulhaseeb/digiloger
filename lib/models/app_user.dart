import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.isVerified = false,
    this.status = true,
    this.isBuiness = false,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.timestamp,
    this.location,
    this.imageURL = '',
    this.followers,
    this.followings,
    this.posts,
    this.events,
  });
  final String uid;
  final String name;
  final String email;
  final bool? status;
  final bool? isVerified;
  final bool? isBuiness;
  final String? phoneNumber;
  final String? dob;
  final String? imageURL;
  final String? gender;
  final String? location;
  final String? timestamp;
  final List<String>? followers;
  final List<String>? followings;
  final List<String>? posts;
  final List<String>? events;

  Map<String, dynamic> toMap() {
    if (isBuiness == true) {
      return <String, dynamic>{
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'isVerified': isVerified ?? false,
        'status': status ?? true,
        'isBuiness': true,
        'location': location ?? '',
        'phoneNumber': phoneNumber,
        'imageURL': imageURL ?? '',
        'timestamp': timestamp ?? DateTime.now(),
        'followers': followers ?? <String>[],
        'followings': followings ?? <String>[],
        'posts': posts ?? <String>[],
        'events': events ?? <String>[],
      };
    } else {
      return <String, dynamic>{
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'isVerified': isVerified ?? false,
        'status': status ?? true,
        'isBuiness': false,
        'dob': dob,
        'imageURL': imageURL ?? '',
        'gender': gender,
        'timestamp': timestamp ?? DateTime.now(),
        'followers': followers ?? <String>[],
        'followings': followings ?? <String>[],
        'posts': posts ?? <String>[],
      };
    }
  }

  // ignore: sort_constructors_first
  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data()!['isBuiness'] == true && doc.data() != null) {
      return AppUser(
        uid: doc.data()!['uid'].toString(),
        name: doc.data()!['name'].toString(),
        email: doc.data()!['email'].toString(),
        isVerified: doc.data()!['isVerified'] ?? false,
        status: doc.data()!['status'] ?? true,
        isBuiness: true,
        location: doc.data()!['location'] ?? '',
        phoneNumber: doc.data()!['phoneNumber'].toString(),
        imageURL: doc.data()!['imageURL'] ?? '',
        timestamp: doc.data()!['timestamp'].toString(),
        followers: List<String>.from(doc.data()!['followers']),
        followings: List<String>.from(doc.data()!['followings']),
        posts: List<String>.from(doc.data()!['posts']),
        events: List<String>.from(doc.data()!['events']),
      );
    } else {
      return AppUser(
        uid: doc.data()!['uid'],
        name: doc.data()!['name'],
        email: doc.data()!['email'],
        isVerified: doc.data()!['isVerified'] ?? false,
        status: doc.data()!['status'] ?? true,
        isBuiness: false,
        dob: doc.data()!['dob'] ?? '',
        imageURL: doc.data()!['imageURL'] ?? '',
        gender: doc.data()!['gender'] ?? 'm',
        timestamp: doc.data()!['timestamp'].toString(),
        followers: List<String>.from(doc.data()!['followers']),
        followings: List<String>.from(doc.data()!['followings']),
        posts: List<String>.from(doc.data()!['posts']),
      );
    }
  }
}
