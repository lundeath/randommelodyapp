import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:randommelody/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randommelody/pages/user_info_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  final auth = FirebaseAuth.instanceFor(
      app: Firebase.app(), persistence: Persistence.NONE);
  await auth.setPersistence(Persistence.LOCAL);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static var db = FirebaseFirestore.instance;
  static var analytics = FirebaseAnalytics.instance;
  static var observer = FirebaseAnalyticsObserver(analytics: analytics);
  static var authState =
      FirebaseAuth.instance.idTokenChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(title: "Random melody", analytics: analytics, observer: observer, db: db),
        // '/user-info': (context) => UserInfoPage(),
      },
      title: 'Random melody app',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
