import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_vault/camera_page.dart';
import 'package:photo_vault/models/database.dart';
import 'package:photo_vault/models/storage.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


// ignore: must_be_immutable
class AlbumPage extends StatefulWidget {
  AlbumPage({required String albumName}){
    this.albumName = albumName;
  }
  String albumName="";
  List<AssetEntity>? assets;
  List<String> photoPaths = [];
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Consumer<DBProvider>(
        builder: (context, db, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.albumName),
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back
                ),
                onPressed: (){
                  Navigator.popUntil(context, ModalRoute.withName('allAlbums'));
                },),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      widget.assets = await AssetPicker.pickAssets(
                        context,
                        themeColor: Colors.blue,
                        textDelegate: EnglishTextDelegate() 
                      );
                      // Add photo paths to database
                      await db.insertPhotos(widget.assets, widget.albumName);
                      setState(() {});
                    },
                    child: Icon(
                      Icons.photo_album_rounded,
                      size: 26.0,
                    ),
                  )
                ),
              ],
            ),
            body:FutureBuilder<List<String>>(
                future: Provider.of<DBProvider>(context).getAlbumPhotos(widget.albumName),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.data.isEmpty){
                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      // itemCount: widget.assets!.length,
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)
                          ),
                          child: Image.file(File(snapshot.data[index]))
                        );
                      });
                  }
                  else if(snapshot.data.isEmpty){
                    return Center(
                      child: Text("No photos yet, add some!")
                    );
                  }
                  else {
                    return SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                        color: Colors.blue,
                      ),
                      width: 60,
                      height: 60,
                    );
                  }
                }
                ),
          );
        }
      );
  }
}