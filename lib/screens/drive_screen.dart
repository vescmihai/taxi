import 'package:flutter/material.dart';
import 'package:uagrm_app/screens/map_screen.dart';
import 'package:uagrm_app/screens/search_autocomplete_screen.dart';

class DriveScreen extends StatefulWidget {
  DriveScreen();

  @override
  DriveScreenState createState() => DriveScreenState();
}

class DriveScreenState extends State<DriveScreen> {
  final TextEditingController _pickup = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Image.network(
            'https://media.tenor.com/y8BqGzWtqSAAAAAi/explore-map.gif',
            width: widthSize * 0.8,
            height: heightSize * 0.4,
            fit: BoxFit.contain,
          ),
          SizedBox(height: heightSize * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: widthSize * 0.02),
              Container(
                width: widthSize * 0.8,
                child: TextField(
                  controller: _pickup,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchAutoCompleteScreen(_pickup),
                    ));
                  },
                  style: TextStyle(fontSize: heightSize * 0.022),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Punto de salida',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widthSize * 0.03,
                      vertical: heightSize * 0.02,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightSize * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: widthSize * 0.02),
              Container(
                width: widthSize * 0.8,
                child: TextField(
                  controller: _destination,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchAutoCompleteScreen(_destination),
                    ));
                  },
                  style: TextStyle(fontSize: heightSize * 0.022),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Punto de llegada',
                    prefixIcon: Icon(Icons.location_on),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widthSize * 0.03,
                      vertical: heightSize * 0.02,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightSize * 0.04),
          ElevatedButton.icon(
            icon: Icon(Icons.car_repair, size: widthSize * 0.06),
            label: Text(
              'Iniciar',
              style: TextStyle(fontSize: widthSize * 0.05),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFFF1522),
              onPrimary: Colors.white,
              minimumSize: Size(widthSize * 0.8, heightSize * 0.06),
              padding: EdgeInsets.symmetric(
                horizontal: widthSize * 0.1,
                vertical: heightSize * 0.02,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () async {
              if (_pickup.text.isNotEmpty && _destination.text.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapScreen(
                    _pickup.value.text,
                    _destination.value.text,
                  ),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
