import 'package:flutter/material.dart';
import 'package:assigment_app/models/UserModel.dart';
import 'package:assigment_app/servies/auth.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthServices _auth = AuthServices();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? userId = _auth.getCurrentUserId();
    if (userId != null) {
      _auth.getUserData(userId).then((userData) {
        if (userData != null) {
          setState(() {
            user = UserModel.fromMap(userData);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.white],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Profile",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white, // Text color
              ),
            ),
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage(
                'assets/images/profile.png',
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              user?.fullName ?? '',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              user?.email ?? '',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Username: ${user?.username ?? ''}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Address: ${user?.address1 ?? ''}, ${user?.address2 ?? ''}, ${user?.address3 ?? ''}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'NIC No: ${user?.nicNo ?? ''}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Contact: ${user?.contact ?? ''}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
