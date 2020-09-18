import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatulita/constants.dart';
import 'package:flutter/services.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
User _firebaseUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isMe;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String message;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try{
    final _user = _auth.currentUser;
    if(_user != null){
      _firebaseUser = _user;
    }}
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        backgroundColor: Color(0xff242130),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff242130),
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () async{
                  try {
                    await _auth.signOut();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/');
                  }catch(e){
                    print(e);
                  }
                }),
          ],
          title: Text('CHAT'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(),
              Container(
                decoration: kMessageContainerDecoration,
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print(_firebaseUser.uid);
                        _firestore.collection('msg').add({
                          'sender' : _firebaseUser.uid,
                          'text' : message,
                          'time': FieldValue.serverTimestamp()
                        });
                        messageTextController.clear();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('msg').orderBy('time', descending: false).snapshots(),
      builder: (context ,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageWidgets = [];
        for(var message in messages){
          final msgText = message.data()['text'];
          final msgSender = message.data()['sender'];

          final currentUser = _firebaseUser.uid;

          final messageWidget = MessageBubble(
            email: msgSender,
            msg: msgText,
            isMe: currentUser == msgSender ,);
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageWidgets,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.email,this.msg,this.isMe});
  final String email;
  final String msg;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 4),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isMe ? [
                      Color(0xff038bff),
                      Color(0xff0f51ff),
                    ] : [
                      Color(0xff322f45),
                      Color(0xff322f45)
                    ]),
              borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) :
                BorderRadius.only(topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30) ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text(msg,
              style: TextStyle(fontSize: 15,
              color:Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
