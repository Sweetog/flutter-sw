import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageUtil {
  static final _storage = FirebaseStorage.instance;
  static final _lg = Logger();

  static Future<String> uploadInlet(File img, String name) async {
    try {
      if (kIsWeb) {
        //web based image upload IS NOT a high priority to fix
        //the web based app is used by the administrator/desk assistant or secretary
        //inlet images are taken out in the field by service workers
        //the administrator will not often need to change photos
        _lg.d("Web image upload not working, NOT a high priority to fix though");
        UploadTask uploadTask = _storage.ref().child('inlets/$name').putData(
              await XFile(img.path).readAsBytes(),
            );
        return (await uploadTask).ref.getDownloadURL();
      } else {
        UploadTask uploadTask =
            _storage.ref().child('inlets/$name').putFile(img);
        return (await uploadTask).ref.getDownloadURL();
      }
    } catch (e) {
      _lg.d("Upload file exception");
      _lg.d(e);
      return "";
    }
  }
}
