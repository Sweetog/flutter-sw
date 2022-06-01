

import 'package:flutter/foundation.dart';

class NavBarIndex {
  static const _offset = kIsWeb ? 1 : 0;

  //these numbers match the index of the nav_bar mmenu array

  static const Home = 0; 
  static const Import = kIsWeb ? _offset : -1; //only used for web
  static const Jobs = 1 + _offset;
  static const Account = 2 + _offset;
}
