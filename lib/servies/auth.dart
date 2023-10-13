import 'package:assigment_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthServices {
  //firebase instence
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user mod from uid
UserModel? _userWithFirebaseUserUid(User? user) {
  return user != null
      ? UserModel(
          uid: user.uid,
          email: '',  
          password: '',  
          fullName: '', 
          username: '',  
          address1: '',  
          address2: '',  
          address3: '', 
          nicNo: '', 
          contact: '',  
        )
      : null;
}
  //create streem
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //register using email and password
Future<UserModel?> registerWithEmailAndPassword(
  String email,
  String password,
  String fullName,
  String username,
  String address1,
  String address2,
  String address3,
  String nicNo,
  String contact,
) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    UserModel? userModel = _userWithFirebaseUserUid(user);

    if (userModel != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.uid)
          .set({
            'email': email,
            'fullName': fullName,
            'username': username,
            'address1': address1,
            'address2': address2,
            'address3': address3,
            'nicNo': nicNo,
            'contact': contact,
          })
          .then((_) {
            print("User data saved successfully");
          })
          .catchError((error) {
            print("Error saving user data: $error");
          });
    }
    
    return _userWithFirebaseUserUid(user);
  } catch (err) {
    print("Registration error: $err");
    return null;
  }
}


  //signin using email and password

  Future signInUsingEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
        print(user);
      return _userWithFirebaseUserUid(user);

    } catch (err) {
      print(err.toString());
      return null;
    }
  }
Future<Map<String, dynamic>?> getUserData(String userId) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') 
        .doc(userId) 
        .get();

    if (userDoc.exists) {
      // If the document exists, return its data as a Map
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  } catch (error) {
    // Handle any errors that may occur during the process
    print("Error fetching user data from Firestore: $error");
    return null;
  }
}
String? getCurrentUserId()  {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null; 
    }
  }
  //sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
