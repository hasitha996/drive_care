import 'package:assigment_app/models/UserModel.dart';
import 'package:assigment_app/screens/wrapper.dart';
import 'package:assigment_app/servies/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.photos.request();
  await Permission.camera.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(
          uid: "",
          email: "",
          password: "",
          fullName: "",
          username: "",
          address1: "",
          address2: "",
          address3: "",
          nicNo: "",
          contact: ""),
      value: AuthServices().user,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: Wrapper()),
    );
  }
}
