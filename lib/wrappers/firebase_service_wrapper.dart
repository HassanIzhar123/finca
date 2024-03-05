import 'package:finca/utils/global_ui.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseServiceWrapper {
  static FirebaseApp? _app;

  static FirebaseApp? get app => _app;

  Future<void> init() async {
    try {
      _app = await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyD9QXhZXi_pMMr3jv0r36Ye0leplbp02r0",
          authDomain: "fincaapp-a4606.firebaseapp.com",
          projectId: "fincaapp-a4606",
          storageBucket: "fincaapp-a4606.appspot.com",
          messagingSenderId: "618662696347",
          appId: "1:618662696347:web:6aebdfda9a920c91883d3e",
        ),
      );
    } catch (e) {
      GlobalUI.showSnackBar('Failed to initialize Firebase');
    }
  }
}
