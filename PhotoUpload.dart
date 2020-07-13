import 'package:flutter/material.dart';
import 'package:flutter_blog_post/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';
 class UploadPhoto extends StatefulWidget{
   State <StatefulWidget> createState(){
     return _UploadPhotoState();
   }
 }

class _UploadPhotoState extends State <UploadPhoto> {
  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    //var tempImage1= await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref()
          .child("Post Images");
      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(
          timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image url = " + url);

      goToHomePage();

      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d,yyyy');
    var formatTime = new DateFormat('EEEE,hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);


    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };

      ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
            return new HomePage();
        }
        )
    );
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Upload"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: sampleImage == null ? Text("Select an image") : enableUpload(),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Add Image',
          child: Icon(Icons.add_a_photo),
        ),
      );
    }
    Widget enableUpload() {
      return SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
                children: <Widget>[
                  Image.file(sampleImage, height: 310.0, width: 600.0),

                  SizedBox(height: 15.0,),

                  RaisedButton(
                    elevation: 10.0,
                    child: Text("Add a new Post"),
                    textColor: Colors.white,
                    color: Colors.pink,

                    onPressed: uploadStatusImage,
                  ),

                  TextFormField(
                    decoration: InputDecoration(labelText: "Caption"),

                    validator: (value) {
                      return value.isEmpty ? "Caption is required" : null;
                    },

                    onSaved: (value) {
                      return _myValue = value;
                    },
                  ),
                ]

            ),
          ),
        ),
      );
    }

}