import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_vault/album_page.dart';
import 'package:photo_vault/models/database.dart';
import 'package:photo_vault/models/password.dart';
import 'package:provider/provider.dart';

class AddAlbum extends StatefulWidget {
  TextEditingController _albumNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  @override
  _AddAlbumState createState() => _AddAlbumState();
}

class _AddAlbumState extends State<AddAlbum> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Album"),
        centerTitle: true,
        // automaticallyImplyLeading: false,

      ),
      body: Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Album name"),
                Container(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Album name"
                    ),
                    // autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: widget._albumNameController
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Password"),
                Container(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Password"
                    ),
                    // autofocus: true,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    // maxLines: 1,
                    maxLength: 6,
                    controller: widget._passwordController
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Confirm password"),
                Container(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Confirm password"
                    ),
                    // autofocus: true,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    // maxLines: 1,
                    controller: widget._confirmPassController
                  ),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
            TextButton(
              child: Text('Add',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                // Check password match
                if(widget._passwordController.text == widget._confirmPassController.text){
                  // Create album in database
                  // String parsedAlbumName = Provider.of<DBProvider>(context,listen: false).whitespaceParser(widget._albumNameController.text);
                  Map<String,Object> album = { "albumName" : widget._albumNameController.text, "NumPhotos": 0};
                  await Provider.of<DBProvider>(context,listen: false).insertAlbums(album);

                  // Add entry to password
                  Provider.of<Passwords>(context, listen: false).setPassword(widget._albumNameController.text, widget._confirmPassController.text);
                  String albumName = widget._albumNameController.text.toString();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => AlbumPage(albumName: albumName)
                    )
                  );

                }
                else {
                  final snackBar = SnackBar(content: Text('Password mismatch! Try again!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  widget._passwordController.clear();
                  widget._confirmPassController.clear();
                }

              },
            ),
            TextButton(
              child: 
              Text('Cancel',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
                // pop to home page
              },
            ),
          ],
          ),
        ]
      ),
    );
  }
  @override
  void dispose() {
      widget._albumNameController.dispose();
      widget._passwordController.dispose();
      widget._confirmPassController.dispose();
      super.dispose();
  }
}