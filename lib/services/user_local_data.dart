import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';

class UserLocalData {
  static late SharedPreferences? _preferences;
  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void signout() => _preferences!.clear();

  static const String _uidKey = 'UIDKEY';
  static const String _displayNameKey = 'DISPLAYNAMEKEY';
  static const String _emailKey = 'EMAILKEY';
  static const String _isBusinessKey = 'ISBUSINESSKEY';
  static const String _isVerifiedKey = 'ISVERIFIEDKEY';
  static const String _imageUrlKey = 'IMAGEURLKEY';
  static const String _followersKey = 'FOLLOWERSKEY';
  static const String _followsKey = 'FOLLOWSKEY';
  static const String _postKey = 'POSTKEY';

  //s
  // Setters
  //
  static Future<void> setUID(String uid) async =>
      _preferences!.setString(_uidKey, uid);

  static Future<void> setDisplayName(String name) async =>
      _preferences!.setString(_displayNameKey, name);

  static Future<void> setEmail(String email) async =>
      _preferences!.setString(_emailKey, email);

  static Future<void> setIsBusiness(bool isBusiness) async =>
      _preferences!.setBool(_isBusinessKey, isBusiness);

  static Future<void> setIsVerified(bool isVerified) async =>
      _preferences!.setBool(_isVerifiedKey, isVerified);

  static Future<void> setImageUrl(String url) async =>
      _preferences!.setString(_imageUrlKey, url);

  static Future<void> setFollowers(List<String> followers) async =>
      _preferences!.setStringList(_followersKey, followers);

  static Future<void> setFollows(List<String> follows) async =>
      _preferences!.setStringList(_followsKey, follows);

  static Future<void> setPost(List<String> post) async =>
      _preferences!.setStringList(_postKey, post);

  //
  // Getters
  //
  static String get getUID => _preferences!.getString(_uidKey) ?? '';
  static String get getName => _preferences!.getString(_displayNameKey) ?? '';
  static String get getEmail => _preferences!.getString(_emailKey) ?? '';
  static bool get getIsBusiness =>
      _preferences!.getBool(_isBusinessKey) ?? false;
  static bool get getIsVerified =>
      _preferences!.getBool(_isVerifiedKey) ?? false;
  static String get getImageUrl => _preferences!.getString(_imageUrlKey) ?? '';
  static List<String> get getFollowers =>
      _preferences!.getStringList(_followersKey) ?? <String>[];
  static List<String> get getFollows =>
      _preferences!.getStringList(_followsKey) ?? <String>[];
  static List<String> get getPost =>
      _preferences!.getStringList(_postKey) ?? <String>[];

  void storeAppUserData({required AppUser appUser}) {
    setUID(appUser.uid);
    setDisplayName(appUser.name);
    setEmail(appUser.email);
    setIsBusiness(appUser.isBuiness ?? false);
    setIsVerified(appUser.isVerified ?? false);
    setImageUrl(appUser.imageURL ?? '');
    setFollowers(appUser.followers ?? <String>[]);
    setFollows(appUser.follows ?? <String>[]);
    setPost(appUser.posts ?? <String>[]);
  }
}
