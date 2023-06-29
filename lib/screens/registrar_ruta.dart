import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uagrm_app/services/firebase_service.dart';
import 'package:uagrm_app/screens/search_autocomplete_screen.dart';

class RegistrarRuta extends StatefulWidget {
  @override
  _RegistrarRutaState createState() => _RegistrarRutaState();
}

class _RegistrarRutaState extends State<RegistrarRuta> {
  final _formKey = GlobalKey<FormState>();
  final _dateFocusNode = FocusNode();
  final _originFocusNode = FocusNode();
  final _destinationFocusNode = FocusNode();
  String username = '';
  DateTime fechaHora = DateTime.now();
  TextEditingController puntoOrigen = TextEditingController();
  TextEditingController puntoDestino = TextEditingController();
  int capacidadPasajeros = 1;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();

    _dateFocusNode.addListener(() {
      if (_dateFocusNode.hasFocus) {
        _dateFocusNode.unfocus();
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            onChanged: (date) {
              setState(() {
                fechaHora = date;
              });
            },
            currentTime: DateTime.now(),
            locale: LocaleType.es);
      }
    });

    _originFocusNode.addListener(() {
      if (_originFocusNode.hasFocus) {
        _originFocusNode.unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchAutoCompleteScreen(puntoOrigen),
          ),
        );
      }
    });

    _destinationFocusNode.addListener(() {
      if (_destinationFocusNode.hasFocus) {
        _destinationFocusNode.unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchAutoCompleteScreen(puntoDestino),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _dateFocusNode.dispose();
    _originFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color(0xffFF1522),
        title: Text('Registrar ruta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _dateFocusNode.requestFocus(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      focusNode: _dateFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Fecha y hora',
                      ),
                      controller: TextEditingController(text: fechaHora.toString()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _originFocusNode.requestFocus(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      focusNode: _originFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Punto de origen',
                      ),
                      controller: puntoOrigen,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _destinationFocusNode.requestFocus(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      focusNode: _destinationFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Punto de destino',
                      ),
                      controller: puntoDestino,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Capacidad de pasajeros'),
                  readOnly: true,
                  controller: TextEditingController(text: capacidadPasajeros.toString()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce la capacidad de pasajeros';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (capacidadPasajeros > 1) {
                            capacidadPasajeros--;
                          }
                        });
                      },
                    ),
                    Text(capacidadPasajeros.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (capacidadPasajeros < 6) {
                            capacidadPasajeros++;
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Procesa los datos
                        String result = await _firebaseService.registrarRuta(
                            puntoOrigen.text, puntoDestino.text, fechaHora, capacidadPasajeros.toString());
                        if (result == 'SUCCESS') {
                          Navigator.of(context).pushReplacementNamed("/home");
                        } else {
                          print("Error: $result");
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Registrar ruta',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF1522)),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFEEEEEE)),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                      elevation: MaterialStateProperty.all<double>(5.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(Size(350, 60)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
