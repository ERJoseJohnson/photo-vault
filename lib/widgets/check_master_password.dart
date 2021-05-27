import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:photo_vault/home_page.dart';
import 'package:photo_vault/models/password.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CheckMasterPassword extends StatefulWidget {

  CheckMasterPassword({required StreamController<bool> verificationNotifier, required String passwordName}){
    this.verificationNotifier = verificationNotifier;
    this.passwordName = passwordName;
  }

  StreamController<bool> verificationNotifier = StreamController();
  String passwordName = "";
  @override
  _CheckMasterPasswordState createState() => _CheckMasterPasswordState();
}

class _CheckMasterPasswordState extends State<CheckMasterPassword> {
  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
        title: Text(
          "Enterer",
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.white
            ),), 
        shouldTriggerVerification: widget.verificationNotifier.stream, 
        deleteButton: Text("Delete"), 
        passwordEnteredCallback: (String text) async {
          print(text+" is the password to check");
          bool checkPass = await Provider.of<Passwords>(context,listen: false).checkPassword(widget.passwordName, text);
          if(checkPass){
            print("password correct!");
            widget.verificationNotifier.add(true);
            // Navigator.push(
            //   context, 
            //   MaterialPageRoute(
            //     builder: (context) => HomePage()));
            
            Navigator.pushNamed(context, 'allAlbums');
            // Change to the next screen
          }
          else{
            print("password incorrect :(");
            widget.verificationNotifier.add(false);
            // SnackBar to reenter password
            final snackBar = SnackBar(content: Text('Password incorrect! Try again!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // reset stream
          }
        }, 
        cancelButton: Text("Cancel"),
      );
  }
}