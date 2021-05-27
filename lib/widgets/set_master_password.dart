import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:photo_vault/home_page.dart';
import 'package:photo_vault/main.dart';
import 'package:photo_vault/models/password.dart';
import 'package:photo_vault/widgets/check_master_password.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable
class SetMasterPassword extends StatefulWidget {
  SetMasterPassword({required StreamController<bool> verificationNotifier, required String passwordName}){
    this.verificationNotifier = verificationNotifier;
    this.passwordName = passwordName;
  }

  StreamController<bool> verificationNotifier = StreamController();
  String passwordName = "";
  @override
  _SetMasterPasswordState createState() => _SetMasterPasswordState();
}

class _SetMasterPasswordState extends State<SetMasterPassword> {
  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
        title: Text(
          "Setter",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
            ),), 
        shouldTriggerVerification: widget.verificationNotifier.stream, 
        deleteButton: Text("Delete"),
        passwordEnteredCallback: (String text) async {
          print(text+" is the password I am going to store");
          await Provider.of<Passwords>(context,listen: false).setPassword(widget.passwordName, text);
          // CheckPassword(verificationNotifier: widget.verificationNotifier, passwordName: widget.passwordName,);
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => Authentication()
            )
          );
        }, 
        cancelButton: Text("Cancel"),
      );
  }
}