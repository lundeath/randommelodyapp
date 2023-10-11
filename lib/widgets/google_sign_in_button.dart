import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randommelody/auth/google_auth.dart';

import '../pages/user_info_page.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  User? _user;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                _user = await GoogleAuth.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

               /* if (_user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserInfoPage(
                        user: _user,
                      ),
                    ),
                  );
                }*/
              },
              child: _user == null
                  ? const ClipOval(
                        child: Image(
                            image: AssetImage("google_logo.png"),
                            height: 30.0,
                          ),
                    )
                  : ClipOval(
                      child: Material(
                        color: Colors.grey.withOpacity(0.3),
                        child: Image.network(
                          _user!.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
            ),
    ]);
  }
}
