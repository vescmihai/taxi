import 'package:flutter/material.dart';
import 'package:carpool_app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _auth = FirebaseService();
  final TextEditingController _filter = TextEditingController();
  Stream<QuerySnapshot>? _searchResult;

  @override
  void initState() {
    super.initState();
    _filter.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _filter.removeListener(_onSearchChanged);
    _filter.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchResult = null;
      });
    } else {
      setState(() {
        _searchResult = _auth.buscarPorPuntoFinal(_filter.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF1522),
        title: TextField(
          controller: _filter,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: 'Buscar ruta',
            hintStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _filter.clear();
              setState(() {
                _searchResult = null;
              });
            },
          ),
        ],
      ),
      body: _searchResult != null ? _buildSearchList() : _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/registrar_ruta'),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFF1522),
      ),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _auth.obtenerRutas(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Ha ocurrido un error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                title: Text(
                  'Origen: ${data['puntoInicial']}\nDestino: ${data['puntoFinal']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'Conductor: ${data['nombreUsuario']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Fecha y hora: ${(data['fechaHora'] as Timestamp).toDate().toString()}',
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Ocupantes disponibles: ${data['detalleAdicional']}',
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSearchList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _searchResult,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Ha ocurrido un error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                title: Text(
                  'Origen: ${data['puntoInicial']}\nDestino: ${data['puntoFinal']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'Conductor: ${data['nombreUsuario']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Fecha y hora: ${(data['fechaHora'] as Timestamp).toDate().toString()}',
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Ocupantes disponibles: ${data['detalleAdicional']}',
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
