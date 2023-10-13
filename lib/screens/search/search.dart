import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  void _search() async {
  final query = _searchController.text;
  if (query.isNotEmpty) {
    final results = await FirebaseFirestore.instance
        .collection('cases')
        .where('vehicleNumber', isGreaterThanOrEqualTo: query)
        .where('vehicleNumber', isLessThan: query + 'z')
        .get();

    // Create a Set to store unique vehicle numbers
    final uniqueValues = <String>{};

    for (final doc in results.docs) {
      final value = doc['vehicleNumber'] as String;
      uniqueValues.add(value);
    }

    setState(() {
      _searchResults = results.docs
          .where((doc) => uniqueValues.contains(doc['vehicleNumber']))
          .toList();
    });
  } else {
    setState(() {
      _searchResults.clear();
    });
  }
}


  void _openDetails(BuildContext context, DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (context) {
        return DetailsPopup(
          document: document,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _search();
              },
              decoration: InputDecoration(
                labelText: "Search by Vehicle Number",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final document = _searchResults[index];
                      return ListTile(
                        title: Text(document['vehicleNumber']),
                        subtitle: Text(document['insuranceDescription']),
                        onTap: () {
                          _openDetails(context, document);
                        },
                      );
                    },
                  )
                : Center(
                    child: Text("No search results"),
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailsPopup extends StatelessWidget {
  final DocumentSnapshot document;
  final VoidCallback onClose;

  DetailsPopup({required this.document, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Case Details",
        textAlign: TextAlign.center, // Center the title
        style: TextStyle(
          color: Colors.blue, // Change the title text color
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Vehicle Number: ${document['vehicleNumber']}",
              style: TextStyle(
                color: Colors.black, // Change the text color
              ),
            ),
          ),
          Center(
            child: Text(
              "Insurance Plan: ${document['insurancePlan']}",
              style: TextStyle(
                color: Colors.black, // Change the text color
              ),
            ),
          ),
          Center(
            child: Text(
              "Insurance Description: ${document['insuranceDescription']}",
              style: TextStyle(
                color: Colors.black, // Change the text color
              ),
            ),
          ),
          Center(
            child: Text(
              "Uploaded Photo URL: ${document['uploadedPhotoUrl']}",
              style: TextStyle(
                color: Colors.black, // Change the text color
              ),
            ),
          ),
          Center(
            child: Text(
              "User ID: ${document['userId']}",
              style: TextStyle(
                color: Colors.black, // Change the text color
              ),
            ),
          ),
          Center(
            child: Text(
              "Status: ${document['status']}",
              style: TextStyle(
                color: Colors.black, // Change the text color
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onClose,
          child: Text(
            "Close",
            style: TextStyle(
              color: Colors.red, // Change the button text color
            ),
          ),
        ),
      ],
    );
    ;
  }
}
