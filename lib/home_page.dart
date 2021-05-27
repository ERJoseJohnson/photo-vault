import 'package:flutter/material.dart';
import 'package:photo_vault/add_album.dart';
import 'package:photo_vault/album_page.dart';
import 'package:photo_vault/models/database.dart';
import 'package:photo_vault/widgets/check_album_password.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return 
    Consumer<DBProvider>(
      builder: (context, db, child){
        return Scaffold(
          appBar: AppBar(
              title: Text(
                "Home Page"),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
            itemCount: db.numOfAlbums!.toDouble().toInt(),
            itemBuilder: (context, index) => GestureDetector(
                      onTap: (){
                        print("tapped on $index album");
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => CheckAlbumPassword(albumName: db.albums[index]["albumName"].toString())
                            // builder: (context) => AlbumPage(albumName: db.albums[index]["albumName"].toString())
                          )
                        );
                      },
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: (){
                      print("Tapped this $index album");
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          // builder: (context) => AlbumPage(albumName: db.albums[index]["albumName"].toString())
                          builder: (context) => CheckAlbumPassword(albumName: db.albums[index]["albumName"].toString())
                        )
                      );
                    }, 
                    icon: Icon(Icons.photo_album_rounded)), 
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(db.albums[index]["albumName"].toString())), 
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(db.albums[index]["NumPhotos"].toString() + " photos"))],
              ),
            )
          ),
          bottomNavigationBar: Container(
            // height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              color: Colors.blue,
            ),
            // padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => AddAlbum())
                    );
                  },  
                  icon: Icon(
                        Icons.photo_album,
                        color: Colors.white,
                        // size: 50.0
                        )
                ),
              ]
            ),
          ),
        );
    });
  }
}