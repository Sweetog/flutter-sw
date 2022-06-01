import 'package:app/screens/import/import_view_model.dart';
import 'package:app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'env.dart';
import '@core/util/sd_colors.dart';
import 'screens/home/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('BUILD APP STARTING');
    return _buildApp();
    // return FutureBuilder(
    //     // Initialize FlutterFire
    //     future: Firebase.initializeApp(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       // Once complete, show application
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return _buildApp();
    //       }

    //       return Loading();
    //     });
  }

  Widget _buildApp() {
    return ChangeNotifierProvider(
      create: (context) => ImportViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: env.flavor == BuildFlavor.test,
        showPerformanceOverlay: false,
        title: 'SD Stormwater Solutions',
        theme: ThemeData(
            //primarySwatch: SdColors().getPrimaryBackgroundColorMaterial(),
            scaffoldBackgroundColor: SdColors.white,
            primarySwatch: SdColors().getPrimaryBackgroundColorMaterial(),
            hintColor: SdColors.primaryForeground,
            brightness: Brightness.light, //overrides primarySwatch
            accentColor: SdColors.accent,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Home(),
      ),
    );
  }
}
