import 'package:flutter/material.dart';
import 'package:flutter_blog_post/Authentication.dart';
import 'Authentication.dart';
import 'Dialogue.dart';

class LoginRegisterPage extends StatefulWidget{
  var title;

  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
});
  final AuthImplementation  auth;
  final VoidCallback onSignedIn;
  //LoginRegisterPage({Key key, this.title}) : super(key: key);
  @override
  _LoginRegisterState createState() => _LoginRegisterState();


}
enum FormType{login,register}

class _LoginRegisterState extends State <LoginRegisterPage>{
  Dialogue dialogue=new Dialogue();
  final formKey=new GlobalKey<FormState>();
  FormType _formType=FormType.login;
  String _email="";
  String _password="";

  bool validateAndSave(){
final form=formKey.currentState;
if(form.validate()){
  form.save();
  return true;
}
else{
  return false;
}
  }

  void validateAndSubmit() async{
    if (validateAndSave()){
      try{
        if(_formType==FormType.login){
          String userId= await widget.auth.SignIn(_email, _password);
         // dialogue.information(context, "Welcome back ! ", " ");
          print("Login userId = "+userId);
        }
        else{
          String userId= await widget.auth.SignUp(_email, _password);
         // dialogue.information(context, "Congratulations ! ", "Your account has been created successfully");
          print("Login userId = "+userId);
        }
        widget.onSignedIn();
      }
      catch(e){
        dialogue.information(context, "Error =", e.toString());
    print("Error = "+e.toString());
      }
    }
  }
  void moveToRegister(){
    formKey.currentState.reset();

    setState(() {
      _formType=FormType.register;
    });

  }
  void moveToLogin(){
    formKey.currentState.reset();

    setState(() {
      _formType=FormType.login;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text('Buzz Bloggers',
            textAlign: TextAlign.center,
          )
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key:formKey,
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:createInputs()+createButtons(),
            ),
          ),
        ),
      ),
    );
  }
  List <Widget> createButtons() {
   if(_formType==FormType.login)
     {
       return [
         RaisedButton(
           child: Text("Login", style: new TextStyle(fontSize: 20.0)),
           textColor: Colors.white,
           color: Colors.pink,
           onPressed:validateAndSubmit,
         ),
         FlatButton(
           child: Text(
               "Do not have an Account ?", style: new TextStyle(fontSize: 14.0)),
           textColor: Colors.pink,
           onPressed: moveToRegister,
         ),

       ];
     }
   else
     {
       return [
         RaisedButton(
           child: Text("Create Account", style: new TextStyle(fontSize: 20.0)),
           textColor: Colors.white,
           color: Colors.pink,
           onPressed:validateAndSubmit,
         ),
         FlatButton(
           child: Text("Alreay have have an account ? Login ?", style: new TextStyle(fontSize: 14.0)),
           textColor: Colors.pink,

           onPressed: moveToLogin,
         ),

       ];
     }
  }
  Widget logo(){
    return new Hero(
      tag:'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child:Image.asset('images/logo1.png'),


      ),
    );
  }

  List <Widget> createInputs(){
    return[
      SizedBox(height: 10.0),
      logo(),
      SizedBox(height: 10.0,),
           new TextFormField(
              decoration:InputDecoration(labelText: 'Email'),
             validator:(value){
             return value.isEmpty ? "Email is required.":null;
           },
               onSaved:(value){
                 return _email=value;
               },


        ),
      SizedBox(height: 10.0,),
      TextFormField(
        decoration:InputDecoration(labelText: 'Password') ,
          obscureText: true,
  validator:(value){
            return value.isEmpty ? "Password is required.":null;
          },
          onSaved:(value){
            return _password=value;
          }
      ),
      SizedBox(height: 20.0,),

    ];
  }}
