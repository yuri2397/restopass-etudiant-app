import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static const String USER_FIRST_NAME = "first_name";
  static const String USER_LAST_NAME = "last_name";
  static const String USER_EMAIL = "email";
  static const String USER_NUMBER = "number";
  static const String USER_ACCESS_TOKEN = "access_token";
  static const String USER_REFRESH_TOKEN = "refresh_token";
  static const String USER_EXPIRE_IN = "expire_in";
  static const String USER_FIRST_TIME = "first_time";
  static const String USER_PAY = "pay";

  SharedPref();

  void addUserFirstName(String firstName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_FIRST_NAME, firstName);
  }

  void addUserNubmer(int number) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(USER_NUMBER, number);
  }

  void addUserPay(int pay) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(USER_PAY, pay);
  }

  void addUserLastName(String lastName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_LAST_NAME, lastName);
  }

  void setFirstTime(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(USER_FIRST_TIME, value);
  }

  void setUserPay(int pay) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(USER_PAY, pay);
  }


  void addUserEmail(String email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_EMAIL, email);
  }

  void addUserAccessToken(String accessToken) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ACCESS_TOKEN, accessToken);
  }

  void addUserRefreshToken(String refreshToken) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_REFRESH_TOKEN, refreshToken);
  }

  void addUserExpireIn(int expireIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(USER_EXPIRE_IN, expireIn);
  }

  Future<bool> getFirstTime() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(USER_FIRST_TIME) ?? false;
  }

  Future<String> getUserFirstName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_FIRST_NAME);
  }

  Future<int> getUserNumber() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(USER_NUMBER);
  }

  Future<String> getUserLastName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_LAST_NAME);
  }

  Future<String> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_EMAIL);
  }

  Future<int> getUserPay() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(USER_PAY);
  }

  Future<String> getUserAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ACCESS_TOKEN);
  }

  Future<String> getUserRefreshToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_REFRESH_TOKEN);
  }

  Future<int> getUserExpireIn(String expireIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(USER_EXPIRE_IN) ?? 0;
  }

  void removeSharedPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_FIRST_NAME);
    prefs.remove(USER_LAST_NAME);
    prefs.remove(USER_EMAIL);
    prefs.remove(USER_ACCESS_TOKEN);
    prefs.remove(USER_REFRESH_TOKEN);
    prefs.remove(USER_EXPIRE_IN);
  }

  Future<bool> isLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(USER_ACCESS_TOKEN);
  }
  
}