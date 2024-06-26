import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/find_locale.dart';
import 'package:ovrsr/firebase_options.dart';
import 'package:ovrsr/pages/account.dart';
//import 'package:ovrsr/pages/home.dart';
import 'package:ovrsr/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ovrsr/utils/apptheme.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await findSystemLocale();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OVRSR',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
      ),
      //color: Colors.purple,
      // scaffoldBackgroundColor: const Colors.white,
      home: const LoginPage(),
      //change to LoginPage()
    );
  }
}
