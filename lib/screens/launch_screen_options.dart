import 'package:uagrm_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class LaunchScreenOptions extends StatelessWidget {
  const LaunchScreenOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    Widget buildOptionButton({required String role, required IconData icon, required String text}) {
      return ElevatedButton.icon(
        icon: Icon(icon, size: widthSize * 0.10),
        label: Column( 
          children: [
            Text(
              text, 
              style: TextStyle(fontSize: widthSize * 0.05),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(  
          primary: Color(0xffFF1522),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          minimumSize: Size(widthSize * 0.80, heightSize * 0.12),
          padding: EdgeInsets.symmetric(
            horizontal: widthSize * 0.10,
            vertical: heightSize * 0.02,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AuthScreen(role.toLowerCase())),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: heightSize * 0.08),
            buildOptionButton(role: 'driver', icon: Icons.directions_car, text: 'Estudiante conductor'),
            SizedBox(height: heightSize * 0.04),
            buildOptionButton(role: 'rider', icon: Icons.school, text: 'Estudiante pasajero'),
          ],
        ),
      ),
    );
  }
}
