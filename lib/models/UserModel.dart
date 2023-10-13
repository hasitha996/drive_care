class UserModel {
  final String uid;
  final String email;
  final String password;
  final String fullName;  
  final String username;
  final String address1;
  final String address2;
  final String address3;
  final String nicNo;
  final String contact;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    required this.fullName,  
    required this.username,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.nicNo,
    required this.contact,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      password:  '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      address3: map['address3'] ?? '',
      nicNo: map['nicNo'] ?? '',
      contact: map['contact'] ?? '',
    );
  }
}