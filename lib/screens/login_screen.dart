import 'package:chatulita/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatulita/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title:'Log in',color: Colors.lightBlueAccent,onPressed: ()async{
                try {
                  setState(() {
                    _showLoad = true;
                  });
                  final _user = await _firebaseAuth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if(_user != null){
                  Navigator.pushNamed(context, '/chatScreen');}
                }catch(e){
                  Toast.show('wrong user credentials',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity:  Toast.TOP);
                }
                setState(() {
                  _showLoad = false;
                });},),
              SizedBox(
                height: 24.0,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Text('New user? click here...',
                textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
