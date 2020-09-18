import 'package:chatulita/screens/phone_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Chatulita());
}

class Chatulita extends StatelessWidget {

  String isLoggedIn(){
    var auth= FirebaseAuth.instance;
    User user = auth.currentUser;
    if(user != null){
      return '/chatScreen';
    }else{
      return '/';
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn(),
      routes: {
        '/' : (context) => WelcomeScreen(),
        '/login' : (context) => LoginScreen(),
        '/register' : (context) => RegistrationScreen(),
        '/chatScreen' : (context) => ChatScreen(),
        '/phoneLogin' : (context) => PhoneLogin()
      },
      theme: ThemeData.dark(),
    );
  }
}
