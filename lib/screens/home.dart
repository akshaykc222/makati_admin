import 'package:flutter/material.dart';
import 'package:makati_admin/screens/add_offers.dart';
import 'package:makati_admin/screens/send_notification.dart';
import 'package:makati_admin/screens/users.dart';
import 'package:side_navigation/side_navigation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Widget> views = const [UserReport(), Offers(), SendNotification()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The row is needed to display the current view
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Users',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Offers',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Push Notifications',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}
