import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CasesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Cases',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: CasesWidget(),
    );
  }
}

class CasesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getCasesWithStatus1(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No cases found.'));
        }
        final cases = snapshot.data!.docs;

        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true, // Allow the inner list to scroll
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final caseData = cases[index].data() as Map<String, dynamic>;
              return Status1CaseCard(caseData: caseData);
            },
          ),
        );
      },
    );
  }
}

class Status1CaseCard extends StatelessWidget {
  final Map<String, dynamic> caseData;

  Status1CaseCard({required this.caseData});

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Case Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${caseData['title']}'),
              Text('Details: ${caseData['details']}'),
              // Add more case properties here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title:  Text('Vehical:${caseData['vehicleNumber']}-Case: ${caseData['title']}'),
        subtitle: Text('Details: ${caseData['details']}'),
        onTap: () {
          _showDetails(context); // Show details dialog when item is tapped
        },
      ),
    );
  }
}

Future<QuerySnapshot> getCasesWithStatus1() {
  return FirebaseFirestore.instance.collection('cases').where('status', isEqualTo: 0).get();
}
