import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:uuid/uuid.dart';

// Unable to implement application specific storage
// Possible problem: getExternalStorageDirectior() Java API deprecated
// Link: https://github.com/flutter/flutter/issues/71355#issuecomment-736321687


class AppStorage extends ChangeNotifier{
  String storagePath = "";
  Directory? directory;
  
  AppStorage(){
    init();
  }

  Future<void> init() async {
    directory = await getExternalStorageDirectory();
    String newPath = "";
    print(directory);
    List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    newPath = newPath + "/PhotoVault";
    directory = Directory(newPath);
    storagePath = newPath;
  }

  Future<void> resolveStorage() async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/PhotoVault";
          directory = Directory(newPath);
          storagePath = newPath;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
          storagePath = directory!.path;
        }
      }
      if (!await directory!.exists()) {
        await directory!.create(recursive: true);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<List<Map<String,dynamic>>> saveImages(List<AssetEntity>? images, String albumName) async {
    
    List<Map<String,dynamic>> newPhotos = [];
    print(directory);
      print(directory!.path);
    // print(images);

    for(var x = 0; x<images!.length; x++){
      var uuid = Uuid();
      String uniqueID;
      uniqueID = uuid.v1();
      print(uniqueID);
      print(directory);
      print(directory!.path);
      File? tempImageFile = await images[x].file;
      File? newImageFile = await tempImageFile!.copy(directory!.path+"/"+uniqueID+".png");
      newPhotos.add({"photoPath": newImageFile.path, "albumName": albumName});
    }

    // images.forEach((element) async {
    //   var uuid = Uuid();
    //   String uniqueID;
    //   uniqueID = uuid.v1();
    //   print(uniqueID);
    //   print(directory);
    //   print(directory!.path);
    //   File? tempImageFile = await element.file;
    //   File? newImageFile = await tempImageFile!.copy(directory!.path+uniqueID+".png");
    //   newPhotos.add({"photoPath": newImageFile.path, "albumName": albumName});
    // });

    return newPhotos;
  }
}