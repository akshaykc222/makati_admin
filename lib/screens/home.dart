import 'package:flutter/material.dart';
import 'package:makati_admin/screens/add_offers.dart';
import 'package:makati_admin/screens/box_request.dart';
import 'package:makati_admin/screens/list_countries.dart';
import 'package:makati_admin/screens/send_notification.dart';
import 'package:makati_admin/screens/service_location_list.dart';
import 'package:makati_admin/screens/users.dart';
import 'package:side_navigation/side_navigation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Widget> views = const [
    UserReport(),
    Offers(),
    SendNotification(),
    ListCountries(),
    LocationList(),
    BoxRequests()
  ];
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
              SideNavigationBarItem(
                icon: Icons.local_airport,
                label: 'Countries',
              ),
              SideNavigationBarItem(
                icon: Icons.location_on,
                label: 'Service Locations',
              ),
              SideNavigationBarItem(
                icon: Icons.location_on,
                label: 'Shipments',
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
