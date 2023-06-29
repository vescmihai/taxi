import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uagrm_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class RegistrarBrevet extends StatefulWidget {
  @override
  _RegistrarBrevetState createState() => _RegistrarBrevetState();
}

class _RegistrarBrevetState extends State<RegistrarBrevet> {
  final _formKey = GlobalKey<FormState>();
  String numero = '';
  DateTime? fechaExpedicion;
  DateTime? fechaVencimiento;
  
  final FirebaseService _firebaseService = FirebaseService();

  File? _brevetImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _brevetImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadBrevetImage() async {
    if (_brevetImage != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('brevetImages/${path.basename(_brevetImage!.path)}');
      UploadTask uploadTask = firebaseStorageRef.putFile(_brevetImage!);
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
        title: Text('Registrar Brevet'),
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

                _buildTextField('Número de serie', (value) => numero = value),
                SizedBox(height: heightSize * 0.02),
                _buildDateTimePicker('Fecha de Expedición', (value) => fechaExpedicion = value),
                SizedBox(height: heightSize * 0.02),
                _buildDateTimePicker('Fecha de Vencimiento', (value) => fechaVencimiento = value),
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
                _brevetImage != null
                  ? Image.file(
                      _brevetImage!,
                      width: widthSize * 0.8,
                      height: heightSize * 0.4,
                      fit: BoxFit.cover,
                    )
                  : Container(),
                
                SizedBox(height: heightSize * 0.02),
                ElevatedButton.icon(
                  icon: Icon(Icons.car_repair, size: widthSize * 0.06), 
                  label: Text(
                    'Registrar Brevet',
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
                      String? imageUrl = await uploadBrevetImage();
                      String result = await _firebaseService.registrarBrevet(numero, fechaExpedicion, fechaVencimiento, imageUrl!);
                      if (result == 'SUCCESS') {
                        Navigator.of(context).pushReplacementNamed("/registrar_vehiculo");
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
            return 'Por favor, introduce el $label del brevet';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateTimePicker(String label, Function(DateTime?) onChanged) {
  DateTime? selectedDate;

  return InkWell(
    onTap: () async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
        onChanged(selectedDate);
      }
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedDate != null
                ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year.toString()}'
                : 'Seleccione una fecha',
          ),
          Icon(Icons.calendar_today),
        ],
      ),
    ),
  );
}

}
