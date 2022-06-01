import 'package:app/screens/account/account.dart';
import 'package:app/screens/import/import.dart';
import 'package:app/screens/jobs/jobs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/home/home.dart';

final Color _iconColor = SdColors.swLightBlue;
final Color unselectedItemColor = SdColors.white70;
final Color selectedItemColor = Colors.amber.shade800;
final Color backgroundColor = SdColors.primaryForeground;
//cannot set BottomNavigationBar item unselected/selected color in TextStyles :shrug
final TextStyle _navBarItemTxtStyle =
    TextStyle(fontFamily: 'Lalezar', fontSize: 15.0);
final TextStyle _navBarItemSelectedTxtStyle =
    TextStyle(fontFamily: 'Lalezar', fontSize: 15.0);

class NavBar extends StatefulWidget {
  final int index;

  NavBar({required this.index});

  @override
  State<StatefulWidget> createState() => _NavBarState(index: index);
}

class _NavBarState extends State<NavBar> {
  int index;

  _NavBarState({required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: unselectedItemColor,
      selectedItemColor: selectedItemColor,
      backgroundColor: backgroundColor,
      unselectedLabelStyle: _navBarItemTxtStyle,
      selectedLabelStyle: _navBarItemSelectedTxtStyle,
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (this.index == index) {
          return;
        }
        setState(() {
          this.index = index;
        });
        _navigateToScreens(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _iconColor,
          ),
          label: 'Home',
        ),
        if (kIsWeb)
          BottomNavigationBarItem(
            icon: Icon(
              Icons.import_export,
              color: _iconColor,
            ),
            label: 'Import',
          ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.auto_delete_sharp,
            color: _iconColor,
          ),
          label: 'Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: _iconColor,
          ),
          label: "Account",
        ),
      ],
    );
  }

  _navigateToScreens(int index) {
    switch (index) {
      case NavBarIndex.Home:
        UIUtil.navigateAsRoot(Home(), context);
        break;
      case NavBarIndex.Import:
        UIUtil.navigateAsRoot(Import(), context);
        break;
      case NavBarIndex.Jobs:
        UIUtil.navigateAsRoot(Jobs(), context);
        break;
      case NavBarIndex.Account:
        UIUtil.navigateAsRoot(Account(), context);
        break;
    }
  }
}
