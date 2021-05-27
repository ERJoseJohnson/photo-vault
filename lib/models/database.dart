import "dart:io" as io;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DBProvider extends ChangeNotifier{
  Database? db;
  int? numOfPhotos = 0; 
  int? numOfAlbums = 0;
  int number = 0;
  var albums = [];
  var photos = [];

  DBProvider(){
    init();
  }

  void init() async {
    final dbPath = await getDatabasesPath();
    db = await openDatabase(
      join(dbPath, 'photoVault.db'),
      onCreate: (db, version) {
        // Create table for photos
        String photosStmt = 'CREATE TABLE Photos (id INTEGER PRIMARY KEY AUTOINCREMENT, photoPath TEXT, albumName TEXT)';
        db.execute(photosStmt);

        // Create table for albums
        String albumsStmt = 'CREATE TABLE Albums (id INTEGER PRIMARY KEY AUTOINCREMENT, albumName TEXT, NumPhotos Integer)';
        return db.execute(albumsStmt);

      },
      version: 1
    );
    numOfPhotos = await rowsInTable("Photos");
    numOfAlbums = await rowsInTable("Albums");
    albums = await getAlbums();
    photos = await getPhotos();
    // notifyListeners();
  }

  Future<int?> rowsInTable(String table) async {
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<void> insertPhotos(List<AssetEntity>? data, String albumName) async {
    List<Map<String,dynamic>>? sqlData = await assetToMap(data,albumName);
    // sqlData!.forEach((element) async {
    for(var element in sqlData!){
      await db!.insert("Photos", element, conflictAlgorithm: ConflictAlgorithm.fail);
    }
    await increasePhotoCount(albumName, sqlData.length.toString());
    photos =await getPhotos();
    notifyListeners();
  }

  Future<void> insertAlbums(Map<String, Object> data) async {
    await db!.insert("Albums", data, conflictAlgorithm: ConflictAlgorithm.fail);
    albums = await getAlbums();
    notifyListeners();
  }

  Future<void> insertItems(String table, Map<String, Object> data) async {
    await db!.insert(table, data, conflictAlgorithm: ConflictAlgorithm.fail);
    if(table=="Albums"){
      albums = await getAlbums();
    } else{
      photos = await getPhotos();
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getPhotos() async {
    return await db!.query("Photos");
  }

  Future<List<Map<String, dynamic>>> getAlbums() async {
    return await db!.query("Albums");
  }

  Future<List<String>> getAlbumPhotos(String albumName) async {
    List<String> photoPaths = [];
    var queryResults = await db!.rawQuery('SELECT photoPath FROM Photos WHERE albumName=?',['$albumName']);
    // queryResults.forEach((element) {
    for(var element in queryResults) {
      photoPaths.add(element["photoPath"].toString());
    }
    return photoPaths;
  }

  Future<void> increasePhotoCount(String albumName, String count) async{
    await db!.rawUpdate('UPDATE Albums SET NumPhotos = NumPhotos+? WHERE albumName = ?',[count,albumName]);
    albums = await getAlbums();
    photos = await getPhotos();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>?> assetToMap(List<AssetEntity>? assets, String albumName) async {
    List<Map<String,dynamic>>? sqlData = [];
    // assets!.forEach((element) async {
    for(var element in assets!){
      print(element);
      File? tempFile = await element.file;
      sqlData.add({"photoPath": tempFile!.path, "albumName": albumName});
    };
    return sqlData;
  }

  String whitespaceParser(String input){
    print(input);
    if(input.contains(' ')){
      // input.split(" ").join("");
      String tempInput = input.trim().replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), '');
      print(tempInput);
      return tempInput;
      // return tempInput;
    }
    return input.trim();
  }
}