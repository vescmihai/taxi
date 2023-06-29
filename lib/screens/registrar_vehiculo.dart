import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carpool_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;



class RegistrarVehiculo extends StatefulWidget {
  @override
  _RegistrarVehiculoState createState() => _RegistrarVehiculoState();
}

class _RegistrarVehiculoState extends State<RegistrarVehiculo> {
  final _formKey = GlobalKey<FormState>();
  String placa = '';
  String marca = '';
  String modelo = '';
  String ano = '';
  int capacidad = 1;
  String? carEspecial;

  final FirebaseService _firebaseService = FirebaseService();

File? _vehicleImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _vehicleImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadVehicleImage() async {
    if (_vehicleImage != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('vehicleImages/${path.basename(_vehicleImage!.path)}');
      UploadTask uploadTask = firebaseStorageRef.putFile(_vehicleImage!);
      await uploadTask.whenComplete(() => print('File Uploaded'));
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar vehículo'),
        backgroundColor: Color(0xffFF1522),
      ),
      body: Padding(
        padding: EdgeInsets.all(heightSize * 0.05),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                _buildTextField('Placa', (value) => placa = value),
                _buildTextField('Marca', (value) => marca = value),
                _buildTextField('Modelo', (value) => modelo = value),
                _buildTextField('Año', (value) => ano = value),

                

                DropdownButtonFormField<String>(
                  value: carEspecial,
                  hint: Text('Característica especial'),
                  items: <String>['Asientos para niños', 'Personas con movilidad reducida', 'Ninguna'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      carEspecial = newValue;
                    });
                  },
                ),
                SizedBox(height: heightSize * 0.02),
                Text('Capacidad de pasajeros'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (capacidad > 1) {
                          setState(() {
                            capacidad--;
                          });
                        }
                      },
                    ),
                    Text(capacidad.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (capacidad < 6) {
                          setState(() {
                            capacidad++;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: heightSize * 0.02),
                SizedBox(height: heightSize * 0.02),
                ElevatedButton.icon(
                  icon: Icon(Icons.image, size: widthSize * 0.06), 
                  label: Text(
                    'Seleccione una foto',
                    style: TextStyle(fontSize: widthSize * 0.05),
                  ),
                    style: ElevatedButton.styleFrom(
                    primary: Colors.grey.shade800,
                    onPrimary: Colors.white,
                    minimumSize: Size(widthSize * 0.80, heightSize * 0.04), 
                    padding: EdgeInsets.symmetric(
                      horizontal: widthSize * 0.10,
                      vertical: heightSize * 0.02,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    getImage();
                  },
                ),

                // Display the selected image
                _vehicleImage != null
                  ? Image.file(
                      _vehicleImage!,
                      width: widthSize * 0.8,
                      height: heightSize * 0.4,
                      fit: BoxFit.cover,
                    )
                  : Container(),
                
                SizedBox(height: heightSize * 0.02),
                ElevatedButton.icon(
                  icon: Icon(Icons.car_repair, size: widthSize * 0.06), 
                  label: Text(
                    'Registrar vehículo',
                    style: TextStyle(fontSize: widthSize * 0.05),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffFF1522),
                    onPrimary: Colors.white,
                    minimumSize: Size(widthSize * 0.80, heightSize * 0.04), 
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
                      // upload image
                      String? imageUrl = await uploadVehicleImage();

                      String result = await _firebaseService.registrarVehiculo(placa, marca, modelo, ano, capacidad.toString(), carEspecial ?? 'Ninguna', imageUrl!);
                      if (result == 'SUCCESS') {
                        Navigator.of(context).pushReplacementNamed("/home");
                      } else {
                        print("Error: $result");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    final heightSize = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: heightSize * 0.01),
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(heightSize * 0.03),
          labelText: label,
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, introduce la $label del vehículo';
          }
          return null;
        },
      ),
    );
  }
}
