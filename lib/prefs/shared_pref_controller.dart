// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:palbazaar/screens/out_boarding_screen.dart';
//
// enum prefKeys{
//   loggIn
// }
// class SharedPrefController{
//
//   static final SharedPrefController _instance = SharedPrefController._internal();
//   late SharedPreferences _sharedPreferences;
//
//   SharedPrefController._internal();
//
//   factory SharedPrefController(){
//     return _instance;
//   }
//   String firstTime= "firstTime";
//   bool firstTimeBool = true ;
//   Future<void> initSharedPref() async{
//     _sharedPreferences = await SharedPreferences.getInstance();
//   }
//
//   Future<void> save({required String inBoard}) async{
//     await _sharedPreferences.setBool(prefKeys.loggIn.toString(), true);
//   }
//   Future<void> saveFirstTime({required String inBoard}) async{
//     await _sharedPreferences.setBool(firstTime, firstTimeBool);
//   }
//
//   bool get loggedIn => _sharedPreferences.getBool(prefKeys.loggIn.toString()) ?? false;
//   bool get getFirstTime => _sharedPreferences.getBool(firstTime) ?? false;
//
//
// }