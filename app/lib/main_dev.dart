import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app/env.dart';
import 'app.dart';

void main() async {
  BuildEnvironment.init(
    flavor: BuildFlavor.test, 
    functionsUrl: 'https://us-central1-stormwater-c643b.cloudfunctions.net/app');
    
  assert(env != null);
  /*
  The flutter framework used the widgetbinding to be able to interact with 
  the flutter engine. When you call ensureInitislized it creates an instance of 
  the Widgetbinding and since Firebase.initializeApp() needs to use platform 
  channels to call native then u need to initialize the binding
  */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
