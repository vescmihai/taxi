import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uagrm_app/screens/signup_screen.dart';
import 'package:uagrm_app/screens/signin_screen.dart';

class AuthScreen extends StatefulWidget {
  final String role;
  const AuthScreen(this.role);
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: const Color(0xffFF1522),
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          PageView(

            controller: controller,
            children: <Widget>[
              SignUpScreen(widget.role),
              SignInScreen(widget.role),
            ],
          ),
          
        ],
      ),
    );
  }
}
