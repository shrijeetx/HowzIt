import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:chatulita/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  FirebaseAuth auth = FirebaseAuth.instance;
  AnimationController controller;
  Animation animation;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this
    );
    animation = ColorTween(begin: Colors.grey,end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String newNumber;
    String sms;
    return Scaffold(
      backgroundColor: Color(0xff242130),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Howzit',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title:'Log in',color: Colors.lightBlueAccent,onPressed: (){
              Navigator.pushNamed(context, '/login');
            },),
            RoundedButton(title: 'login using number',color: Colors.blueAccent,onPressed: (){
              Navigator.pushNamed(context, '/phoneLogin');
            },),
          ],
        ),
      ),
    );
  }
}


