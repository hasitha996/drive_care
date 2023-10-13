import 'package:assigment_app/constants/colors.dart';
import 'package:assigment_app/servies/auth.dart';
import 'package:assigment_app/models/UserModel.dart'; 
import 'package:flutter/material.dart';
import '../../constants/description.dart';
import '../home/dashbord.dart';
import '../search/search.dart';
import '../profile/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Create an object from AuthService
  final AuthServices _auth = AuthServices();

  // Define a variable to track the currently selected tab index
  int _currentIndex = 0;

  // Define a list of pages to be displayed for each tab
  final List<Widget> _pages = [
    // Add  content widgets for each tab here
    DashboardTab(),
    SearchTab(),
    ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgBlack,
          title: const Text("DriveCare"), 
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(bgBlack),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
        body: _pages[_currentIndex], // Display the selected tab's content
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // Set the current tab index
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the selected tab index
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
