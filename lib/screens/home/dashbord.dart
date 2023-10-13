import 'package:assigment_app/servies/auth.dart';
import 'package:flutter/material.dart';
import 'package:assigment_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assigment_app/constants/globals.dart';

import '../home/case_list.dart';

class DashboardTab extends StatefulWidget {
  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final AuthServices _auth = AuthServices();
  UserModel? user;
  List<String> vehicleOptions = [];
  String? selectedVehicle;
  String? selectedInsurancePlan;
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _insuranceDescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _vehicalNumberValue = "";
  String? caseTitle;
  String? caseCategory;
  String? caseDetails;
  List<String> caseImageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchVehicleOptions();
  }

  String? loginId = "";
  Future<void> _fetchUserData() async {
    String? userId = _auth.getCurrentUserId();
    loginId = userId;
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

  Future<void> _fetchVehicleOptions() async {
    String? userId = _auth.getCurrentUserId();
    if (userId != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('insurance_data')
            .where('userId', isEqualTo: userId)
            .get();

        Set<String> uniqueOptions = Set<String>();

        querySnapshot.docs.forEach((doc) {
          final vehicleNumber = doc['vehicleNumber'] as String;
          uniqueOptions.add(vehicleNumber);
        });

        List<String> options = uniqueOptions.toList();

        setState(() {
          vehicleOptions = options;
        });
      } catch (e) {
        print('Error fetching vehicle options: $e');
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Vehicle Insurance"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "most comprehensive vehicle insurance policy available in Sri Lanka. It offers several additional benefits such as on-the-spot settlement of claims and a similar replacement vehicle for repairs that exceed four days. It also provides emergency roadside assistance, plastic surgery cover for lady drivers as well as enhancement of the sum insured by 10% every year for free, entitlement to No Claim bonus irrespective of claims, and payment of lease rentals up to two months for repairs that exceed 30 days in the event of an accident, a 10-year warranty against manufacturing defects and a host of other benefits",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _inputController,
                        decoration: InputDecoration(labelText: "Vehicle Number"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the vehicle number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _vehicalNumberValue = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text("Select Insurance Plan:"),
                      ListTile(
                        title: const Text('3rd Party'),
                        leading: Radio<String>(
                          value: '3rd Party',
                          groupValue: selectedInsurancePlan,
                          onChanged: (value) {
                            setState(() {
                              selectedInsurancePlan = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Full'),
                        leading: Radio<String>(
                          value: 'Full',
                          groupValue: selectedInsurancePlan,
                          onChanged: (value) {
                            setState(() {
                              selectedInsurancePlan = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _insuranceDescriptionController,
                        decoration: InputDecoration(labelText: "Insurance Description"),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _uploadVehiclePhoto,
                        child: Text("Upload Vehicle Photo"),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          ),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text("Submit"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? uploadedImageUrl;
  void _uploadVehiclePhoto() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final imageFile = File(pickedFile.path);
        final storage = FirebaseStorage.instance;

        final directoryPath = 'vehicle_images/$loginId/';
        final filename = '${DateTime.now()}.jpg';

        final imageRef = storage.ref().child(directoryPath).child(filename);

        final uploadTask = imageRef.putFile(imageFile);
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          uploadedImageUrl = imageUrl;
        });

        print("Image uploaded. URL: $imageUrl");
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print("No image selected.");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance.collection('insurance_data').add({
          'vehicleNumber': _vehicalNumberValue,
          'insurancePlan': selectedInsurancePlan ?? "",
          'insuranceDescription': _insuranceDescriptionController.text ?? "",
          'uploadedPhotoUrl': uploadedImageUrl ?? "",
          'userId': loginId ?? "",
          'status': "Pending",
          'timestamp': FieldValue.serverTimestamp(),
        });

       Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        print('Error submitting data: $e');
      }
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _insuranceDescriptionController.dispose();
    super.dispose();
  }

  final List<String> imageList = [
    'assets/images/image1.png',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
  ];

  List<Asset> resultList = [];

  Future<void> _requestPermissionsAndUpload() async {
    Permission.photos.status.isGranted;
    final PermissionStatus cameraStatus = await Permission.camera.request();
    final PermissionStatus photosStatus = await Permission.photos.request();

    _uploadCaseImages();
  }

  Future<void> _uploadCaseImages() async {
  String error = 'No Error Detected';

  try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: 5 - caseImageUrls.length,
      enableCamera: true,
    );
  } on Exception catch (e) {
    error = e.toString();
  }

  if (!mounted) return;

  if (resultList.isNotEmpty) {
    for (Asset asset in resultList) {
      try {
        final ByteData byteData = await asset.getByteData();
        final List<int> imageData = byteData.buffer.asUint8List();

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('case_images/${DateTime.now()}.jpg');
        final UploadTask uploadTask = storageRef.putData(
          Uint8List.fromList(imageData),
        );
        final TaskSnapshot snapshot = await uploadTask;
        final String imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          caseImageUrls.add(imageUrl);
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  } else {
    print('No images selected.');
  }
}


  void _submitCase(Position? location) async {
    if (caseTitle != null &&
        caseCategory != null &&
        caseDetails != null) {
      try {
        await FirebaseFirestore.instance.collection('cases').add({
          'vehicleNumber': selectedVehicle,
          'title': caseTitle,
          'category': caseCategory,
          'details': caseDetails,
          'images': caseImageUrls,
          'location': location?.latitude,
          'status': 0,
          'userId': loginId ?? ""
         
        });

          Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        print('Error submitting case data: $e');
      }
    } else {
      print('Please fill in all case details and upload at least one image.');
    }
  }

  void _openCaseDialog() async {
    Position? location;
    try {
      location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting GPS location: $e");
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Open Case"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "Case"),
                    onChanged: (value) {
                      setState(() {
                        caseTitle = value;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: caseCategory,
                    hint: Text("Select Case Category"),
                    items: [
                      "Accident Claims",
                      "Theft Claims",
                      "Vandalism Claims",
                      "Liability Claims",
                      "Unins/Underins Motorist Claims",
                      "Comprehensive Claims",
                      "Personal Injury Protect Claims",
                      "No-Fault Claims",
                      "Total Loss Claims",
                      "Rental Reimbursement Claims",
                      "Towing and Roadside Assist Claims"
                    ].map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        caseCategory = newValue;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Case Details"),
                    onChanged: (value) {
                      setState(() {
                        caseDetails = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _requestPermissionsAndUpload(),
                    child: Text("Upload Images"),
                  ),
                  Column(
                    children: caseImageUrls.map((imageUrl) {
                      return Image.network(imageUrl);
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitCase(location),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text("Submit Case"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              user != null ? "Welcome, ${user!.username}!" : "Loading...",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: selectedVehicle,
              hint: Text(
                "Select a Vehicle",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              items: vehicleOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return vehicleOptions.map<Widget>((String item) {
                  return Text(
                    item,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  );
                }).toList();
              },
              onChanged: (newValue) {
                setState(() {
                  selectedVehicle = newValue;
                });
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
            CarouselSlider.builder(
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Image.asset(imageList[index]);
              },
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showDialog,
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text("New Insurance Plan"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _openCaseDialog,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text("Open Case"),
            ),
            Container(
              height: 200,
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CasesList(),
            ),
          ],
        ),
      ),
    );
  }
}
