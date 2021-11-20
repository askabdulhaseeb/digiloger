import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
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
  final List<String>? follows;
  final List<String>? posts;
  final List<String>? events;

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
    this.follows,
    this.posts,
    this.events,
  });

  Map<String, dynamic> toMap() {
    if (isBuiness == true) {
      return {
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
        'followers': followers ?? [],
        'follows': follows ?? [],
        'posts': posts ?? [],
        'events': events ?? [],
      };
    } else {
      return {
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
        'followers': followers ?? [],
        'follows': follows ?? [],
        'posts': posts ?? [],
      };
    }
  }

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data()!['isBuiness'] == true) {
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
        follows: List<String>.from(doc.data()!['follows']),
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
        follows: List<String>.from(doc.data()!['follows']),
        posts: List<String>.from(doc.data()!['posts']),
      );
    }
  }
}
