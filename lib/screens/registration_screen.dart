import 'package:chatulita/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatulita/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _showLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff242130),
      body: ModalProgressHUD(
        color: Colors.transparent,
        inAsyncCall: _showLoad,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email.'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password.'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register',color: Colors.blueAccent,onPressed: ()async{
                try {
                  setState(() {
                    _showLoad = true;
                  });
                  final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, '/chatScreen');
                  }
                }catch(e){
                  Toast.show('Use valid Email and strong password',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity:  Toast.TOP);
                }
                setState(() {
                  _showLoad = false;
                });
              },),
            ],
          ),
        ),
      ),
    );
  }
}
