import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CalificarViajeScreen extends StatefulWidget {
  @override
  _CalificarViajeScreenState createState() => _CalificarViajeScreenState();
}

class _CalificarViajeScreenState extends State<CalificarViajeScreen> {
  final _formKey = GlobalKey<FormState>();
  double rating = 0.0;
  String comentario = '';

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calificar viaje'),
        backgroundColor: Color(0xffFF1522),
      ),
      body: Padding(
        padding: EdgeInsets.all(heightSize * 0.05),
        child: Form(
          key: _formKey,
          child: Center( 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Add this
              children: [
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                  },
                ),
                SizedBox(height: heightSize * 0.06),
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
                      print('Calificación: $rating, Comentario: $comentario');
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'Reportar un problema',
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
                    if (_formKey.currentState!.validate()) {
                      print('Calificación: $rating, Comentario: $comentario');
                      Navigator.pushNamed(context, '/reportes');
                    }
                  },
                )
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
