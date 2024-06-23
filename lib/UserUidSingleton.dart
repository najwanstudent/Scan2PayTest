class UserUidSingleton {
  static final UserUidSingleton _singleton = UserUidSingleton._internal();

  factory UserUidSingleton() {
    return _singleton;
  }

  UserUidSingleton._internal();

  String _userUid = ''; // Default empty string

  String get userUid => _userUid;

  set userUid(String value) {
    // Ensure value is not null
    assert(value.isNotEmpty, 'userUid cannot be null or empty');
    _userUid = value;
 }
}