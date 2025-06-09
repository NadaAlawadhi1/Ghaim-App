import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/screens/add.dart';
import 'package:social_media/screens/home.dart';
import 'package:social_media/screens/profile.dart';
import 'package:social_media/screens/search.dart';
import 'package:social_media/screens/notification.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});
  @override
  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _currentIndex = 0;
  PageController _pageCon = PageController();
  void initState() {
    super.initState();
    Provider.of<Userprovider>(context, listen: false).getDetails();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageCon.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<Userprovider>(context).isLoad
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
          )
        : Scaffold(
            extendBody: true,
            body: PageView(
              controller: _pageCon,
              children: [
                HomeScreen(),
                SearchScreen(),
                AddScreen(),
                NotificationScreen(), // Add your NotificationScreen here
                ProfileScreen(),
              ],
              onPageChanged: _onItemTapped,
            ),
            bottomNavigationBar: Container(
              child: NavigationBar(
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: '',
                    selectedIcon: Icon(
                      Icons.home,
                      color: kPrimaryColor,
                    ),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.search),
                    label: '',
                    selectedIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                  ),
                  // Center Add button
                  NavigationDestination(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    label: '',
                    selectedIcon: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.notifications),
                    label: '',
                    selectedIcon: Icon(
                      Icons.notifications,
                      color: kPrimaryColor,
                    ),
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: '',
                    selectedIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
                elevation: 0,
                indicatorColor: Colors.transparent,
                backgroundColor: kWhiteColor,
                selectedIndex: _currentIndex,
                onDestinationSelected: _onItemTapped,
              ),
            ),
          );
  }
}
