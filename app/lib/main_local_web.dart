import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';

import 'env.dart';

void main() async {
  var relativeFunctionsUrl = 'stormwater-c643b/us-central1/app';

  var functionsUrl =
      'http://localhost:5001/$relativeFunctionsUrl'; //android simualtor

  BuildEnvironment.init(flavor: BuildFlavor.test, functionsUrl: functionsUrl);
  assert(env != null);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(App());
}
