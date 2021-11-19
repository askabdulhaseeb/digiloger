class Utilities {
  static double get padding => 16;
  static double get borderRadius => 24;
  static String getGreetingsText() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}
