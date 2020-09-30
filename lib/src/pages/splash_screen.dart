import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = false;
  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Text(
        "You are not Connected to Internet",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      // actions: [
      //   RaisedButton(
      //     onPressed: () {},
      //     child: Text('Turn On'),
      //   ),
      // ],
    );
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      isInternetOn = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isInternetOn = true;
      setState(() async {
        wifiBSSID = await (Connectivity().getWifiBSSID());
        wifiIP = await (Connectivity().getWifiIP());
        wifiName = await (Connectivity().getWifiName());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getConnect();
    // connected ? loadData() : Container();
    // loadData();
  }

  void loadData() {
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
        try {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        } catch (e) {}
      }
    });
  }

  // bool connected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;
                  if (connected) {
                    loadData();

                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/img/logo.png',
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 50),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return buildAlertDialog();

                    // Center(
                    //   child: Container(
                    //     child: Text(
                    //       'You are Offline',
                    //       style: TextStyle(fontSize: 20, color: Colors.black),
                    //     ),
                    //   ),
                    // );

                    // Stack(
                    //   fit: StackFit.expand,
                    //   children: [
                    //     child,
                    //     Positioned(
                    //       left: 0.0,
                    //       right: 0.0,
                    //       height: 32.0,
                    //       child: AnimatedContainer(
                    //         duration: const Duration(milliseconds: 300),
                    //         color: connected
                    //             ? Color(0xFF00EE44)
                    //             : Color(0xFFEE4400),
                    //         child: connected
                    //             ? Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     "YOU ARE ONLINE",
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                 ],
                    //               )
                    //             : Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     "YOU ARE OFFLINE",
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                   SizedBox(
                    //                     width: 8.0,
                    //                   ),
                    //                   SizedBox(
                    //                     width: 12.0,
                    //                     height: 12.0,
                    //                     child: CircularProgressIndicator(
                    //                       strokeWidth: 2.0,
                    //                       valueColor:
                    //                           AlwaysStoppedAnimation<Color>(
                    //                               Colors.white),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //       ),
                    //     ),
                    //   ],
                    // );
                  }
                },
                child: Center(
                  child: Text("ONLINE Or OFFLINE"),
                ),
              );
            },
          ),
        ));

    //  !isInternetOn
    //     ? buildAlertDialog()
    //     :
    // Container(
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).scaffoldBackgroundColor,
    //     ),
    //     child: Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.max,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Image.asset(
    //             'assets/img/logo.png',
    //             width: 150,
    //             fit: BoxFit.cover,
    //           ),
    //           SizedBox(height: 50),
    //           CircularProgressIndicator(
    //             valueColor: AlwaysStoppedAnimation<Color>(
    //                 Theme.of(context).hintColor),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
  }
}
