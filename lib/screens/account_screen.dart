import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  List<RouteData> data = [];

  @override
  void initState() {
    super.initState();
    obtenerCantidadDeRutasUsuario().then((routeData) {
      setState(() {
        data = routeData;
      });
    });
  }

  Future<List<RouteData>> obtenerCantidadDeRutasUsuario() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid; 
    List<int> counts = await obtenerCountsRutasUsuario(currentUserId);

    List<RouteData> routeData = [];
    DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String dayOfWeek = _getDayOfWeek(date.weekday);
      int count = counts[i];

      routeData.add(RouteData(dayOfWeek, count));
    }

    return routeData;
  }

  Future<List<int>> obtenerCountsRutasUsuario(String userId) async {
    List<int> counts = [];
    DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));

      
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rutas')
          .where('usuarioId', isEqualTo: userId)
          .where('fechaHora', isGreaterThanOrEqualTo: date)
          .where('fechaHora', isLessThanOrEqualTo: date.add(Duration(days: 1)))
          .get();

      counts.add(snapshot.size);
    }

    return counts;
  }

  String _getDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'L';
      case 2:
        return 'M';
      case 3:
        return 'X';
      case 4:
        return 'J';
      case 5:
        return 'V';
      case 6:
        return 'S';
      case 7:
        return 'D';
      default:
        return '';
    }
  }

 @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    return Container(
      height: heightSize, 
      color: Color(0xFFEEEEEE), 
      child: Center(
        child: SizedBox(
          width: widthSize,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              ColumnSeries<RouteData, String>(
                color: Color(0xFFFF1522), 
                dataSource: data,
                xValueMapper: (RouteData route, _) => route.dayOfWeek,
                yValueMapper: (RouteData route, _) => route.routeCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RouteData {
  final String dayOfWeek;
  final int routeCount;

  RouteData(this.dayOfWeek, this.routeCount);
}
