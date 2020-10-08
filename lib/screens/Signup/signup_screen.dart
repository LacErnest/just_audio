import 'package:flutter/material.dart';
import 'package:filex/api/databasehelper.dart';
import 'package:filex/screens/Login/login_screen.dart';
import 'package:filex/screens/Signup/components/background.dart';
import 'package:filex/screens/Signup/components/or_divider.dart';
import 'package:filex/screens/Signup/components/social_icon.dart';
import 'package:filex/components/already_have_an_account_acheck.dart';
import 'package:filex/components/rounded_button.dart';
import 'package:filex/components/rounded_input_field.dart';
import 'package:filex/components/rounded_password_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatefulWidget {
  final String title;
  SignUpScreen({Key key , this.title}) : super(key : key);
  

  @override
  SignUpScreenState  createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus = '';

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  _onPressed(){
    setState(() {
      if(_emailController.text.trim().toLowerCase().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty ){
        databaseHelper.registerData(_usernameController.text.trim(),_emailController.text.trim().toLowerCase(),

            _passwordController.text.trim()).whenComplete((){
          if(databaseHelper.status){
            _showDialog();
            msgStatus = 'Check email or password';
            print(msgStatus);
          }else{
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: LoginScreen(),
              ),
            );
          }
        });
      }
    });
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Username",
              controller: _usernameController,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Your Email",
              controller: _emailController,
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: _passwordController,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () { _onPressed(); },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
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
            content:  new Text('An Error occured'),
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
