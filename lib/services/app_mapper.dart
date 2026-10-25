class AppMapper {
  static const Map<String, String> packageToAppModel = {
    'com.instagram.android': 'Instagram',
    'com.google.android.youtube': 'YouTube',
    'com.zhiliaoapp.musically': 'TikTok',
    'com.twitter.android': 'Twitter / X',
    'com.reddit.frontpage': 'Reddit',
  };

  static String? getAppName(String packageName) {
    return packageToAppModel[packageName];
  }
}