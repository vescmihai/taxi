import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:async';

class FirebaseService {
  void initialization() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static String currentUserRole = "NONE";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;

  
  String _failureReason = "None";

  String getCurrentUserRole() {
    return currentUserRole;
  }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }



  Future<Map> getFullName() async {
    print(currentUserRole);
    var data = await _firestoredb
        .collection("users")
        .doc(_auth.currentUser?.uid)
        .get();

    return {
      "firstName": data.data()!["firstName"],
      "lastName": data.data()!["lastName"]
    };
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> newRiderRequest() {
    return _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("requests")
        .snapshots();
  }

  void changeIsDrivingStatus(bool status) async {
    await _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"isDriving": status});
  }

  Future<String> newDriveRequest(var directions) async {
    var docQuery = await _firestoredb
        .collection("users")
        .where("role", isEqualTo: 'driver')
        .where("userId", isNotEqualTo: _auth.currentUser!.uid)
        .where("isDriving", isEqualTo: true)
        .get();

    var data = await _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();

    CollectionReference riderRequestcollectionReference = await _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("requests");

    if (docQuery.docs.isEmpty) {
      riderRequestcollectionReference
          .doc("DUNAVAILABLE")
          .set({"status": "DUNAVAILABLE"});
      return "DUNAVAILABLE";
    } else {
      var doc = await riderRequestcollectionReference.doc("DUNAVAILABLE").get();
      if (doc.exists) {
        riderRequestcollectionReference
            .doc("DUNAVAILABLE")
            .delete()
            .then((value) => print("Delete DUNAVAILABLE document"))
            .catchError(
                (error) => print("Failed to delete DUNAVAILABLE document"));
      }
    }

    DocumentReference documentReference = docQuery.docs[0].reference;
    String driverDocumentID = documentReference.id;

    CollectionReference driverRequestsCollection =
        documentReference.collection("requests");
    String currentTime = DateTime.now().toString();

    try {
      await driverRequestsCollection.doc(_auth.currentUser!.uid).set({
        "riderId": _auth.currentUser!.uid,
        "riderName": data["firstName"] + " " + data["lastName"],
        "timeStamp": currentTime,
        "status": "PENDING",
        "distance": directions['distanceInMiles'],
        "start_loc_lat": directions["start_location"]["lat"],
        "start_loc_lng": directions["start_location"]["lng"]
      });

      riderRequestcollectionReference.doc(driverDocumentID).set({
        "driverId": driverDocumentID,
        "timeStamp": currentTime,
        "status": "PENDING",
        "distance": directions['distanceInMiles'],
        "start_loc_lat": directions["start_location"]["lat"],
        "start_loc_lng": directions["start_location"]["lng"]
      });

      return "PENDING";
    } catch (err) {
      await driverRequestsCollection.doc(_auth.currentUser!.uid).set({
        "timeStamp": currentTime,
        "status": "ERROR",
        "riderId": _auth.currentUser!.uid
      });

      riderRequestcollectionReference.doc(driverDocumentID).set({
        "timeStamp": currentTime,
        "status": "ERROR",
        "driverId": driverDocumentID
      });

      return "ERROR";
    }
  }

  Future<bool> changeRideRequestStatus(String status) async {
    try {
      var doc = await _firestoredb
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("requests")
          .get();

      String riderDocumentId = doc.docs[0].reference.id;
      await doc.docs[0].reference.update({"status": status});

      await _firestoredb
          .collection("users")
          .doc(riderDocumentId)
          .collection("requests")
          .doc(_auth.currentUser!.uid)
          .update({"status": status});

      return true;
    } catch (err) {
      return false;
    }
  }


Future<String> getUserProfileImageURL() async {
  if (_auth.currentUser == null) {
    throw Exception('User not authenticated');
  }

  DocumentSnapshot<Map<String, dynamic>>? documentSnapshot = await _firestoredb
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .get();

  if (documentSnapshot != null && documentSnapshot.exists) {
    Map<String, dynamic> userData = documentSnapshot.data()!;

    if (userData.containsKey('imageUrl')) {
      return userData['imageUrl'];
    } else {
      throw Exception('imageUrl not found in the user document');
    }
  } else {
    throw Exception('User document not found');
  }
}

  Future<String> registrarRuta(String puntoInicial, String puntoFinal, DateTime fechaHora, String detalleAdicional) async {
  try {
    // Revisa si el usuario actual es nulo
    if (_auth.currentUser == null) {
      throw Exception('Usuario no autenticado');
    }

    // Obtiene los datos del usuario de Firestore
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestoredb
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .get();

    Map<String, dynamic>? userData = userSnapshot.data();
    if (userData == null) {
      throw Exception('No se encontraron datos de usuario');
    }

    String? firstName = userData['firstName'];
    if (firstName == null) {
      throw Exception('No se encontró el firstName en los datos del usuario');
    }

    // Crea una referencia al documento en la colección 'rutas' con un ID único
    DocumentReference docRef = _firestoredb.collection('rutas').doc();

    // Crea un objeto para representar los datos de la ruta
    Map<String, dynamic> ruta = {
      'usuarioId': _auth.currentUser!.uid,
      'nombreUsuario': firstName, // Añade el nombre del usuario
      'puntoInicial': puntoInicial,
      'puntoFinal': puntoFinal,
      'fechaHora': Timestamp.fromDate(fechaHora),  // Guarda la fecha y hora como una marca de tiempo de Firestore
      'detalleAdicional': detalleAdicional,
    };

    // Guarda los datos en Firestore
    await docRef.set(ruta);

    // Si no se lanza ninguna excepción, la operación fue exitosa
    return 'SUCCESS';
  } catch (e) {
    // Devuelve el mensaje de error si algo sale mal
    return e.toString();
  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> buscarPorPuntoFinal(String puntoFinal) {
  return _firestoredb
      .collection('rutas')
      .snapshots();
}

Stream<QuerySnapshot> searchByEnd(String end) {
    return _firestoredb
        .collection('rutas')
        .where('puntoFinal', isEqualTo: end)
        .snapshots();
  }



Stream<QuerySnapshot<Map<String, dynamic>>> obtenerRutas() {
  return _firestoredb.collection('rutas').snapshots();
}

Future<int> obtenerCantidadDeRutasUsuario(String usuarioId) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await _firestoredb
      .collection('rutas')
      .where('usuarioId', isEqualTo: usuarioId)
      .get();

  return snapshot.size;
}






Future<String> registrarBrevet(String numero, DateTime? fechaExpedicion, DateTime? fechaVencimiento, String imageUrl) async {
  try {
    // Revisa si el usuario actual es nulo
    if (_auth.currentUser == null) {
      throw Exception('Usuario no autenticado');
    }

    // Crea una referencia al documento en la colección 'brevets' para el usuario actual
    DocumentReference docRef = _firestoredb.collection('brevets').doc(_auth.currentUser!.uid);

    // Crea un objeto para representar los datos del brevet
    Map<String, dynamic> brevet = {
      'numero': numero,
      'fechaExpedicion': fechaExpedicion,
      'fechaVencimiento': fechaVencimiento,
      'imageUrl': imageUrl,
    };

    // Guarda los datos en Firestore
    await docRef.set(brevet);

    // Si no se lanza ninguna excepción, la operación fue exitosa
    return 'SUCCESS';
  } catch (e) {
    // Devuelve el mensaje de error si algo sale mal
    return e.toString();
  }
}

Future<String> getVehiclePlaca() async {
  // Revisa si el usuario actual está autenticado
  if (_auth.currentUser == null) {
    throw Exception('Usuario no autenticado');
  }

  // Obtiene los datos del vehículo del usuario desde Firestore
  DocumentSnapshot<Map<String, dynamic>> vehicleSnapshot = await _firestoredb
      .collection("vehiculos")
      .doc(_auth.currentUser!.uid)
      .get();

  Map<String, dynamic>? vehicleData = vehicleSnapshot.data();
  if (vehicleData == null) {
    throw Exception('No se encontraron datos de vehículo para el usuario');
  }

  String? placa = vehicleData['placa'];
  if (placa == null) {
    throw Exception('No se encontró la placa en los datos del vehículo');
  }

  return placa;
}


Future<String> getVehicleImageURL() async {
    if (_auth.currentUser == null) {
      throw Exception('User not authenticated');
    }

    DocumentSnapshot<Map<String, dynamic>>? documentSnapshot = await _firestoredb
        .collection("vehiculos")
        .doc(_auth.currentUser!.uid)
        .get();

    if (documentSnapshot != null && documentSnapshot.exists) {
      Map<String, dynamic> userData = documentSnapshot.data()!;

      if (userData.containsKey('imageUrl')) {
        return userData['imageUrl'];
      } else {
        throw Exception('imageUrl not found in the user document');
      }
    } else {
      throw Exception('User document not found');
    }
  }



  Future<String> registrarVehiculo(String placa, String marca, String modelo, 
                                    String ano, String capacidad, String carEspecial, String _vehicleImageUrl) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('Usuario no autenticado');
      }

      DocumentReference docRef = _firestoredb.collection('vehiculos').doc(_auth.currentUser!.uid);

      Map<String, dynamic> vehiculo = {
        'placa': placa,
        'marca': marca,
        'modelo': modelo,
        'ano': ano,
        'capacidad': capacidad,
        'carEspecial': carEspecial,
        'imageUrl': _vehicleImageUrl, 
      };

      // Guarda los datos en Firestore
      await docRef.set(vehiculo);

      // Si no se lanza ninguna excepción, la operación fue exitosa
      return 'SUCCESS';
    } catch (e) {
      // Devuelve el mensaje de error si algo sale mal
      return e.toString();
    }
  }



Future signUp(BuildContext context, String firstName, String lastName, String registro,
    String celular, String carrera,
    String email, String password, String imageUrl, String role) async {  
  print("Sign Up!");

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String timestamp = DateTime.now().toString();
    DocumentReference documentReference =
        _firestoredb.collection("users").doc(userCredential.user?.uid);
    var uuid = Uuid();
    var v1 = uuid.v1();
    currentUserRole = role;

    Map<String, dynamic> userObj;

    if (role == 'driver') {
      userObj = {
        "firstName": firstName,
        "lastName": lastName,
        "registro": registro,
        "celular": celular,
        "carrera": carrera,
        "role": role,
        "timestamp": timestamp,
        "userId": userCredential.user?.uid ?? v1,
        "imageUrl": imageUrl,  
      };
    } else {
      userObj = {
        "firstName": firstName,
        "lastName": lastName,
        "registro": registro,
        "celular": celular,
        "carrera": carrera,
        "isDriving": false,
        "role": role,
        "timestamp": timestamp,
        "userId": userCredential.user?.uid ?? v1,
        "imageUrl": imageUrl,  
      };
    }

      documentReference
          .set(userObj)
          .whenComplete(() => print("Data stored successfully"));

      // Aquí está el cambio. Si el usuario es un conductor, navega a RegistrarVehiculoScreen
      if (role == 'driver') {
        Navigator.of(context).pushNamed("/registrar_brevet");
      } else {
        Navigator.of(context).pushReplacementNamed("/home");
      }

      _failureReason = "None";
      return _failureReason;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _failureReason = 'The password provided is too weak.';
        return _failureReason;
      } else if (e.code == 'email-already-in-use') {
        _failureReason = 'The account already exists for that email.';
        return _failureReason;
      } else {
        _failureReason = e.message.toString();
        return _failureReason;
      }
    } catch (e) {
      _failureReason = e.toString();
      return _failureReason;
    }
  }


  Future sigInWithEmail(
      BuildContext context, String email, String password, String role) async {
    print("login");

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      var data = await _firestoredb
          .collection("users")
          .doc(_auth.currentUser?.uid)
          .get();

      currentUserRole = data.data()!["role"];
      print("currentUserRole" + currentUserRole);
      print("role" + role);
      if (currentUserRole != role) {
        _failureReason = 'Please sign in as a ${currentUserRole}';
      } else {
        Navigator.of(context).pushReplacementNamed("/home");
        _failureReason = "None";
      }
      return _failureReason;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _failureReason = "User not found";
        return _failureReason;
      } else if (e.code == 'wrong-password') {
        _failureReason = 'Wrong password provided for that user.';
        return _failureReason;
      } else {
        _failureReason = e.message.toString();
        return _failureReason;
      }
    } catch (e) {
      _failureReason = e.toString();
      return _failureReason;
    }
  }

  String getEmail() {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.email ?? "Trouble getting email.";
    }
    return "Email found not found.";
  }



  Future<String> signOut() async {
    if (_auth.currentUser != null) {
      try {
        await _auth.signOut();
        currentUserRole = "NONE";
        return "SUCCESS";
      } catch (e) {
        return "FAILED";
      }
    }
    return "FAILED";
  }
}
