import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'app.dart';
import 'dart:io' show Platform;

import 'env.dart';

void main() async {
  var relativeFunctionsUrl = 'stormwater-c643b/us-central1/app';

  var functionsUrl =
      'http://10.0.2.2:5001/$relativeFunctionsUrl'; //android simualtor

  if (Platform.isIOS) {
    functionsUrl = 'http://macog.local:5001/$relativeFunctionsUrl'; //ios simulator
  }

  BuildEnvironment.init(flavor: BuildFlavor.test, functionsUrl: functionsUrl);
  assert(env != null);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(App());
}
