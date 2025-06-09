import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:social_media/layout.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/screens/auth/loginScreen.dart';
import 'package:social_media/screens/auth/registerScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Userprovider(),
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.white,
        )),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return LayoutScreen();
              } else {
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
