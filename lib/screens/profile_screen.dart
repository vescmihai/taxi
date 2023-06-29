import 'package:uagrm_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
String _vehiclePlaca = '';
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _auth = FirebaseService();
  late TextEditingController _emailController;
  late TextEditingController _nombreController;
  late TextEditingController _placaController;

  @override
  void initState() {
    _emailController = TextEditingController(text: _auth.getEmail());
    _nombreController = TextEditingController(text: _auth.getCurrentUserRole());
    _fetchVehiclePlaca();
    super.initState();
  }
  void _fetchVehiclePlaca() async {
    try {
      String placa = await _auth.getVehiclePlaca();
      setState(() {
        _vehiclePlaca = placa;
      });
    } catch (e) {
     
    }
  }
  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.symmetric(vertical: heightSize * 0.05),
      child: SingleChildScrollView(
        child: Column(
          children: [
            
            SizedBox(height: heightSize * 0.05),
            FutureBuilder<String>(
              future: _auth.getUserProfileImageURL(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Icon(Icons.error);
                  } else {
                    return Container(
                      width: heightSize * 0.2,
                      height: heightSize * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            SizedBox(height: heightSize * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.10),
                  child: FutureBuilder<Map>(
                    future: _auth.getFullName(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Map> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Text(
                            snapshot.data!["firstName"] +
                                " " +
                                snapshot.data!["lastName"],
                            style: TextStyle(
                              fontSize: heightSize * 0.03,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ];
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: heightSize * 0.01),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: heightSize * 0.06,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: heightSize * 0.02,
                              bottom: 15,
                              left: widthSize * 0.02,
                              right: widthSize * 0.02,
                            ),
                            child: Text(
                              'We are having some problem getting your details. \n Please try again later.',
                              style: TextStyle(
                                fontSize: widthSize * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ];
                      } else {
                        children = const <Widget>[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ];
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthSize * 0.1),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widthSize * 0.05,
                      vertical: heightSize * 0.02,
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),

              
        

            ),

           Padding(
  padding: EdgeInsets.symmetric(horizontal: widthSize * 0.1),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      controller: TextEditingController(text: _vehiclePlaca),
      decoration: InputDecoration(
        labelText: 'Placa del vehículo',
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widthSize * 0.05,
          vertical: heightSize * 0.02,
        ),
        prefixIcon: Icon(Icons.directions_car),
      ),
    ),
  ),
),


            SizedBox(height: heightSize * 0.02),
            SizedBox(height: heightSize * 0.02),
            SizedBox(height: heightSize * 0.02),
            SizedBox(height: heightSize * 0.02),
             ElevatedButton.icon(
              icon: Icon(Icons.logout, size: widthSize * 0.06),
              label: Text(
                'Cerrar sesión',
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
                var res = await _auth.signOut();
                if (res == 'SUCCESS') {
                  Navigator.of(context).pushReplacementNamed('/launchscreenoptions');
                } else {
                  print("Something went wrong. Please try again!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}