import 'package:finca/utils/global_ui.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseServiceWrapper {
  static FirebaseApp? _app;

  static FirebaseApp? get app => _app;

  Future<void> init() async {
    try {
      _app = await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDx_RwBtt1z4RmcxGDuzBVDDSq9XdMV4EU",
          authDomain: "app-fincas-bea92.firebaseapp.com",
          projectId: "app-fincas-bea92",
          storageBucket: "app-fincas-bea92.appspot.com",
          messagingSenderId: "110398898377",
          appId: "1:110398898377:web:fd300661c406c6c2a30d18",
        ),
      );
    } catch (e) {
      GlobalUI.showSnackBar('Failed to initialize Firebase');
    }
  }
}
