import 'package:cargaliberada/screens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCXb_D7G_8eYMS8MX8tRyqXZ-mRj0LoCso",
        authDomain: "cargaliberada-edab3.firebaseapp.com",
        projectId: "cargaliberada-edab3",
        storageBucket: "cargaliberada-edab3.appspot.app",
        messagingSenderId: "168255024061",
        appId: "1:168255024061:web:e78736a3de0eae81ed80d4",
        measurementId: "G-9M9R2Q6MPZ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Carga Liberada', home: LoginScreen());
  }
}
