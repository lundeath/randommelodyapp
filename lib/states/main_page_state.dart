import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:randommelody/pages/login_page.dart';

import '../auth/google_auth.dart';
import '../pages/main_page.dart';
import '../pages/tabs_page.dart';
import '../widgets/google_sign_in_button.dart';

class MainPageState extends State<MainPage> {
  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _writeInDb() async {
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "first": "Alan",
      "middle": "Mathison",
      "last": "Turing",
      "born": 1912
    };

// Add a new document with a generated ID
    widget.db.collection("users").add(user).then((DocumentReference doc) =>
        setMessage('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<void> _getFromDb() async {
    await widget.db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        setMessage("${doc.id} => ${doc.data()}");
      }
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    // Only strings and numbers (longs & doubles for android, ints and doubles for iOS) are supported for GA custom event parameters:
    // https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#+logeventwithname:parameters:
    // https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics#public-void-logevent-string-name,-bundle-params
    await widget.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
      },
    );

    setMessage('logEvent succeeded');
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FutureBuilder(
            future: GoogleAuth.initializeFirebase(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error initializing Firebase');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const GoogleSignInButton();
              }
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepOrangeAccent,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            MaterialButton(
              onPressed: _sendAnalyticsEvent,
              child: const Text('Test logEvent'),
            ),
            MaterialButton(
              onPressed: _testSetCurrentScreen,
              child: const Text('Test setCurrentScreen'),
            ),
            MaterialButton(
              onPressed: _writeInDb,
              child: const Text('Write in DB'),
            ),
            MaterialButton(
              onPressed: _getFromDb,
              child: const Text('Read from DB'),
            ),
            Text(
              _message,
              style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0)),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<TabsPage>(
              settings: const RouteSettings(name: TabsPage.routeName),
              builder: (BuildContext context) {
                return TabsPage(widget.observer);
              },
            ),
          );
        },
        child: const Icon(Icons.tab),
      ),
    );
  }
}
