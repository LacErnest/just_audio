import 'package:flutter/material.dart';
import 'package:filex/screens/Signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filex/api/databasehelper.dart';
import 'package:filex/screens/Login/components/background.dart';
import 'package:filex/components/already_have_an_account_acheck.dart';
import 'package:filex/components/rounded_button.dart';
import 'package:filex/components/rounded_input_field.dart';
import 'package:filex/components/rounded_password_field.dart';
import 'package:filex/screens/main_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key , this.title}) : super(key : key);
  final String title;

  @override
  LoginScreenState  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus = '';

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();


  _onPressed(){
    setState(() {
      if(_usernameController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty ){
        databaseHelper.loginData(_usernameController.text.trim(),
          _passwordController.text.trim()).whenComplete((){
            if(databaseHelper.status){
              _showDialog();
              msgStatus = 'Check username or password';
            }else{
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: MainScreen(),
                ),
              );
            }
        });
      }
    });
  }
  
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    print('Value : $value');
    if(value != 0){
      print('dive into');
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: MainScreen(),
        ),
      );
    }
  }

  @override
  initState(){
    read();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Username",
              controller: _usernameController,
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: _passwordController,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () { _onPressed(); },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    )
    );
  }


  void _showDialog(){
    showDialog(
      context:context ,
      builder:(BuildContext context){
        return AlertDialog(
          title: new Text('Failed'),
          content:  new Text('Check your email or password'),
          actions: <Widget>[
            new RaisedButton(
              child: new Text(
                'Close',
                 ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}
