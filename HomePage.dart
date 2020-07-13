import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
class HomePage extends StatefulWidget{
  HomePage({
   this.auth,
    this.onSignedOut,
});
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
 // HomePage({Key key, this.title}) : super(key: key);
 // final String title;
  @override
  _HomePage createState() => _HomePage();

}
class _HomePage extends State<HomePage>{
  List <Posts> postList=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference postsRef=FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS=snap.value.keys;
      var DATA=snap.value;
      
      
      postList.clear();
      for(var individualKey in KEYS){
        Posts  posts=new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );
        postList.add(posts);
      }
      setState(() {
        print("Length : $postList.length");
      });
    });

  }
  void _logoutUser()async {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e){
      print("Error = "+e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home",
        ),
        centerTitle: true,
      ),
      body: Container(
          child: postList.length==0?Text("NO BLIG POSTS AVAILABLE"):ListView.builder(
            itemCount: postList.length,
            itemBuilder: (_, index){
                return PostsUI(postList[index].image,postList[index].description,postList[index].date,postList[index].time);
            }
          )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: EdgeInsets.only(left: 60,right: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_library),
                iconSize: 40,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed:(){
                  Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context){
                        return new UploadPhoto();
                  })
                  );
                },
              ),


            ],

          ),
        ),
      ),
    );
  }

      Widget PostsUI(String image,String description,String date,String time){
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),


      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            
            SizedBox(height: 10.0,),

            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
            Image.network(image,fit:BoxFit.cover,)

          ],
        ),
      ),
    );
      }

}