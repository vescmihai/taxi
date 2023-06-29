import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String comentario = '';
  String? _reportOption;
  List<String> _reportOptions = [
    'Comportamiento inapropiado',
    'Falta de puntualidad',
    'Problemas con el vehículo',
    'Problemas con la ruta',
    'Otro'
  ];

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reportar problema'),
        backgroundColor: Color(0xffFF1522),
      ),
      body: Padding(
        padding: EdgeInsets.all(heightSize * 0.05),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: _reportOption,
                  decoration: InputDecoration(
                    labelText: "Motivo del reporte",
                    border: OutlineInputBorder(),
                  ),
                  items: _reportOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _reportOption = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona un motivo del reporte.';
                    }
                    return null;
                  },
                ),

                SizedBox(height: heightSize * 0.02),
                _reportOption == 'Otro'
                    ? _buildTextField('Especifica', (value) => comentario = value)
                    : Container(),
                SizedBox(height: heightSize * 0.02),
                _buildTextField('Comentario', (value) => comentario = value),
                SizedBox(height: heightSize * 0.02),
                ElevatedButton(
                  child: Text(
                    'Enviar',
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Motivo del reporte: $_reportOption, Comentario: $comentario');
                      Navigator.pushNamed(context, '/home');
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
            return 'Por favor, introduce un comentario.';
          }
          return null;
        },
      ),
    );
  }
}
