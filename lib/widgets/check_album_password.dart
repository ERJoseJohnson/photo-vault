import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:photo_vault/album_page.dart';
import 'package:photo_vault/home_page.dart';
import 'package:photo_vault/models/password.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CheckAlbumPassword extends StatefulWidget {

  CheckAlbumPassword({required String albumName}){
    this.albumName = albumName;
  }
  // ignore: close_sinks
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  String albumName = "";
  @override
  _CheckAlbumPasswordState createState() => _CheckAlbumPasswordState();
}

class _CheckAlbumPasswordState extends State<CheckAlbumPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Album Password"),
        centerTitle: true,
      ),
      body: 
        PasscodeScreen(
            title: Text(
              "Enterer",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: Colors.white
                ),), 
            shouldTriggerVerification: widget._verificationNotifier.stream, 
            deleteButton: Text("Delete"), 
            passwordEnteredCallback: (String text) async {
              print(text+" is the password to check");
              bool checkPass = await Provider.of<Passwords>(context,listen: false).checkPassword(widget.albumName, text);
              if(checkPass){
                print("password correct!");
               widget._verificationNotifier.add(true);
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => AlbumPage(albumName: widget.albumName)
                  )
                );
              }
              else{
                print("password incorrect :(");
               widget._verificationNotifier.add(false);
                // SnackBar to reenter password
                final snackBar = SnackBar(content: Text('Password incorrect! Try again!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }, 
            cancelButton: Text("Cancel"),
          ),
      
    );
  }
  
  @override
  void dispose() {
    widget._verificationNotifier.close();
    super.dispose();
  }
}