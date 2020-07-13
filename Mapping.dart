import 'package:flutter/material.dart';
import 'loginRegisterPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MappingState();
  }
}
enum AuthStatus{notSignedIn,signedIn}

class _MappingState extends State<MappingPage> {
  AuthStatus authStatus=AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId){
      setState(() {
        authStatus=firebaseUserId==null?AuthStatus.notSignedIn:AuthStatus.signedIn;
      });
    });
  }
  void _signedOut(){
    setState(() {
      authStatus=AuthStatus.notSignedIn;
    });
  }
  void _signedIn(){
    setState(() {
      authStatus=AuthStatus.signedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(authStatus)
    {

      case AuthStatus.notSignedIn:
        return LoginRegisterPage(
         auth: widget.auth,
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.signedIn:
       return HomePage(
         auth:widget.auth,
         onSignedOut:_signedOut,
       );
        break;
    }
    return null;
  }
}