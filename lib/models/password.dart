import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Passwords extends ChangeNotifier{
  // Create storage
  final storage = new FlutterSecureStorage();

  Future<bool> isPasswordSet(String key) async {
    String? isPassSet = await storage.read(key: key);
    // String? isPassSet = await storage.read(key: "badPassword");
    if(isPassSet == null){
      return false;
    }
    return (isPassSet.isEmpty)?false:true;
  }

  Future<void> setPassword(String dbKey, String pass) async {

    // // Create hashed value
    // var bytes = utf8.encode(pass);
    // Digest digest = sha1.convert(bytes);
    
    // await storage.write(key: "master", value: digest.toString());
    await storage.write(key: dbKey, value: pass);
    notifyListeners();
  }

  Future<bool> checkPassword(String dbKey, String pass) async {
    // var bytes = utf8.encode(pass);
    // Digest digest = sha1.convert(bytes);
    
    // String? stringDigest = await storage.read(key: "master");
    String? storedPassword = await storage.read(key: dbKey);

    if(storedPassword == null){
      return false;
    }
    // else if (stringDigest == digest.toString()){
    else if (storedPassword == pass){
      return true;
    }
    else{
      return false;
    }
  }

}