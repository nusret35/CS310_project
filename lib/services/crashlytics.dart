import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashService{

  static final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  static Future<void> setUserID(String uid) async {
    await crashlytics.setUserIdentifier(uid);
  }

  static Future<void> recordError(dynamic e, StackTrace? stackTrace,String reason, bool fatal) async {
    await crashlytics.recordError(e, stackTrace, reason: reason, fatal: fatal );
  }

}