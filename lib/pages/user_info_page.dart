import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:randommelody/main.dart';
import 'package:randommelody/pages/login_page.dart';
import 'package:randommelody/pages/main_page.dart';

import '../auth/google_auth.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key, required User? user})
      : _user = user,
        super(key: key);

  final User? _user;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late User? _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).popUntil(ModalRoute.withName("/"));
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.lightGreen,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.lightGreen,
            title: const Text("User info page"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(),
                  _user?.photoURL != null
                      ? ClipOval(
                          child: Material(
                            color: Colors.grey.withOpacity(0.3),
                            child: Image.network(
                              _user!.photoURL!,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Material(
                            color: Colors.grey.withOpacity(0.3),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Hello',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _user!.displayName!,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '( ${_user!.email!} )',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 14,
                        letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 16.0),
                  _isSigningOut
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.redAccent,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await GoogleAuth.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}
