import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:photo_vault/add_album.dart';
import 'package:photo_vault/album_page.dart';
import 'package:photo_vault/home_page.dart';
import 'package:photo_vault/models/database.dart';
import 'package:photo_vault/models/password.dart';
import 'package:photo_vault/models/storage.dart';
import 'package:photo_vault/widgets/check_master_password.dart';
import 'package:photo_vault/widgets/set_master_password.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
          providers:[
            ChangeNotifierProvider(create: (context) => Passwords()),
            ChangeNotifierProvider(create: (context) => AppStorage()),
            ChangeNotifierProvider(create: (context) => DBProvider()),
          ], 
        child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<DBProvider>(context).init();
    return MaterialApp(
      title: 'Photo Vault',
      routes: {
        'allAlbums': (BuildContext context) => HomePage(),
        'addAlbum': (BuildContext context) => AddAlbum(),
        // 'album': (BuildContext context) => AlbumPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authentication(),
    );
  }
}

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {

    return Consumer<Passwords>(
      builder: (context, passwords, child){
      return Scaffold(
        appBar: AppBar(
          title: Text("Photo Vault"),
        ),
        body: FutureBuilder<bool>(
          future: passwords.isPasswordSet("master"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data){
              return CheckMasterPassword(verificationNotifier: _verificationNotifier, passwordName: "master",);
            }
            else if(!snapshot.data){
              return SetMasterPassword(passwordName: "master", verificationNotifier: _verificationNotifier);
            }
            else if (snapshot.data == null) {
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              );
            }
            else {
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              );
            }
          })
      );
      }
    );
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
