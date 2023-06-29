import 'package:carpool_app/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    final user = Provider.of<User?>(context);

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.grey.shade200,
      primary: Color(0xffFF1522),
      minimumSize: Size(widthSize * 0.10, heightSize * 0.035),
      padding: EdgeInsets.symmetric(
          horizontal: widthSize * 0.10, vertical: heightSize * 0.035),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );

    Widget buildPage({required Widget child, required Color color}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: color,
        child: Center(child: child),
      );
    }

    if (user == null) {
      return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: controller,
              children: <Widget>[
                buildPage(
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'UAGRM TAXI',
                        style: TextStyle(
                            fontSize: widthSize * 0.10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800),
                      ),
                      Text(
                        '¡Optimiza tu tiempo y costos!',
                        style: TextStyle(
                            fontSize: widthSize * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800),
                      ),
                      Image.asset(
                        'assets/carouselscreen1.png',
                        height: heightSize * 0.40,
                        width: widthSize * 0.80,
                      )
                    ],
                  ),
                ),
                buildPage(
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'Comience hoy a compartir transporte',
                        style: TextStyle(
                            fontSize: widthSize * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800),
                      ),
                      SizedBox(height: heightSize * 0.08),
                      Image.asset(
                        'assets/carouselscreen2.png',
                        height: heightSize * 0.35,
                        width: widthSize * 0.60,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: heightSize * 0.20,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  effect: WormEffect(
                      dotWidth: 12,
                      dotHeight: 12,
                      activeDotColor: Colors.redAccent),
                  onDotClicked: (index) => controller.animateToPage(index,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOutQuad),
                ),
              ),
            ),
            Positioned(
              bottom: heightSize * 0.04,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(heightSize * 0.02),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/launchscreenoptions');
                  },
                  child: const Text('Comenzar'),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return BaseScreen();
    }
  }
}
