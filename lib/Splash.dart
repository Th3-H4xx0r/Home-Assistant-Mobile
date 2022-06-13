import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_assistant/Houses.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future handleLoad() async {
    Future.delayed(const Duration(milliseconds: 3000)).then((_) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Houses()));
    });
  }

  @override
  void initState() {
    handleLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Image.asset("lib/images/home_assistant_logo.png", width: MediaQuery.of(context).size.width * 0.17
                      ),
                    ),

                    Image.asset("lib/images/home_assistant_logo_text.png", width: MediaQuery.of(context).size.width * 0.45
                    ),
                  ],
                ),
              )
            ),
          ],
        )
      ),
    );
  }
}
