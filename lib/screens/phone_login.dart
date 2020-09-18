import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatulita/constants.dart';
import 'package:chatulita/components/rounded_button.dart';

class PhoneLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    String sms;
    return Scaffold(
      backgroundColor: Color(0xff242130),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter phone number...'),
                controller: textEditingController,
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton(title:'Log in',color: Colors.lightBlueAccent,
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.verifyPhoneNumber(
                      phoneNumber: '+91${textEditingController.text.trim()}',
                      timeout: const Duration(seconds: 60),
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        Navigator.of(context).pop();
                        UserCredential result =
                            await auth.signInWithCredential(credential);
                        User user = result.user;
                        if (user != null) {
                          Navigator.pushNamed(context, '/chatScreen');
                        }
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        print(e);
                      },
                      codeSent: (String code, int i) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            child: AlertDialog(
                              backgroundColor: Color(0xff1c1926),
                              title: Text('Enter the code'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      sms = value;
                                    },
                                    decoration: kTextFieldDecoration,
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text('Submit'),
                                  onPressed: () async {
                                    AuthCredential credential =
                                        PhoneAuthProvider.credential(
                                            verificationId: code, smsCode: sms);
                                    UserCredential result = await auth
                                        .signInWithCredential(credential);
                                    User user = result.user;
                                    if (user != null) {
                                      Navigator.pushNamed(
                                          context, '/chatScreen');
                                    }
                                  },
                                )
                              ],
                            ));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
