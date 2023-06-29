import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uagrm_app/services/firebase_service.dart';

class SignInScreen extends StatefulWidget {
  final String role;
  const SignInScreen(this.role);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = true;
  String _failureReason = '';
  final FirebaseService _auth = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
  backgroundColor: Colors.grey.shade200,
  body: Center( //Agrega este widget
    child: SingleChildScrollView( 
      child: Container(
        padding: EdgeInsets.all(heightSize * 0.05),
        margin: EdgeInsets.only(top: heightSize * 0.02),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Text('Identificarse',
                    style: TextStyle(
                        fontSize: heightSize * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800)),
                Container(
                  width: widthSize * 0.60,
                  alignment: Alignment.center,
                  child: _success
                      ? Text("")
                      : Container(
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          child: Text(
                            _success ? '' : _failureReason,
                            style: TextStyle(
                                color: Colors.red, fontSize: heightSize * 0.02),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.login, size: widthSize * 0.06), // Puedes cambiar este icono si quieres uno diferente
                  label: Text(
                    'Autenticarse',
                    style: TextStyle(fontSize: widthSize * 0.05),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffFF1522),
                    onPrimary: Colors.white,
                    minimumSize: Size(widthSize * 0.80, heightSize * 0.04), // El mismo tamaño que proporcionaste en el ejemplo
                    padding: EdgeInsets.symmetric(
                      horizontal: widthSize * 0.10,
                      vertical: heightSize * 0.02,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String response = await _auth.sigInWithEmail(
                        context,
                        _emailController.value.text,
                        _passwordController.value.text,
                        widget.role,
                      );
                      print(response);
                      if (response != "None") {
                        setState(() {
                          _success = false;
                          _failureReason = response;
                        });
                      }
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(heightSize * 0.005),
                ),
                
                Container(
                  margin: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: Text(
                    '¿No tiene cuenta? Registrarse',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: heightSize * 0.015),
                  ),
                ),
                
],
                ),
              ),
            ),
          ),
        ));
  }
}
