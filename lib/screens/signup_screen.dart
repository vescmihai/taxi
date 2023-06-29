import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:carpool_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen(this.role);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _registro = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _carrera = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseService _auth = FirebaseService();

  bool _success = true;
  String _failureReason = '';

    // Definiciones de variables para la imagen
  File? _imageFile;
  final picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Container(
          padding: EdgeInsets.all(heightSize * 0.05),
          margin: EdgeInsets.only(top: heightSize * 0.02),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // NEW
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  Container(
                    alignment: Alignment.center,
                    child: _success
                        ? Text("")
                        : Container(
                            margin: const EdgeInsets.all(7),
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.red,
                            )),
                            child: Text(
                              _success ? '' : _failureReason,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                  ),

                  if (_imageFile == null)
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: pickImage,
                      iconSize: 100.0,
                    )
                  else
                    ClipOval(  // NEW
                      child: Image.file(
                        _imageFile!,
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,  // NEW
                      ),
                    ),
                  SizedBox(height: heightSize * 0.02),
                  Padding(
                  padding: EdgeInsets.only(bottom: heightSize * 0.01),
                  child: TextFormField(
                    controller: _firstName,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Nombre',
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
                    controller: _lastName,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Apellido',
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
                    controller: _registro,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Número de registro universitario',
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
                    controller: _celular,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Número de teléfono',
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
                    controller: _carrera,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(heightSize * 0.03),
                      hintText: 'Carrera',
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
                SizedBox(height: heightSize * 0.02),
                  ElevatedButton.icon(
                    icon: Icon(Icons.app_registration, size: widthSize * 0.06), // Cambia este icono si quieres uno diferente
                    label: Text(
                      'Registrar',
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
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        if (_imageFile != null) {
                          var snapshot = await _storage.ref().child('profilePics/${_emailController.text}').putFile(_imageFile!);
                          var downloadUrl = await snapshot.ref.getDownloadURL();

                          String response = await _auth.signUp(
                            context,
                            _firstName.value.text,
                            _lastName.value.text,
                            _registro.value.text,
                            _celular.value.text,
                            _carrera.value.text,
                            _emailController.value.text,
                            _passwordController.value.text,
                            downloadUrl,  // Nueva URL de descarga
                            widget.role,
                          );

                          if (response != "None") {
                            setState(() {
                              _success = false;
                              _failureReason = response;
                            });
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Debe seleccionar una foto de perfil.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Volver'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(heightSize * 0.010),
                  ),


                  Container(
                    margin: EdgeInsets.only(bottom: heightSize * 0.01),
                    child: Text(
                      '¿Ya está registrado? Autenticarse',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: heightSize * 0.015,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ));
  }
}
