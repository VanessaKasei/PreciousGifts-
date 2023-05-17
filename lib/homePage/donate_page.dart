import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonatePage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final home;
  final String homeId;

  const DonatePage({Key? key, required this.home, required this.homeId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  bool _foodChecked = false;
  bool _clothingChecked = false;
  dynamic _selectedCentre;

  Future<void> _submitDonation() async {
    try {
      if (!_foodChecked && !_clothingChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please select the donation type you want to make')),
        );
        return;
      }
      if (_selectedCentre == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a center')),
        );
      }
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final donationRef =
          FirebaseFirestore.instance.collection('donations').doc();
      await donationRef.set({
        'userId': userId,
        'homeId': widget.homeId,
        'center': jsonDecode(_selectedCentre)["name"],
        'officerId': jsonDecode(_selectedCentre)["officerId"],
        'food': _foodChecked,
        'clothing': _clothingChecked,
        'time': DateTime.now(),
        'received': false,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation submitted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting donation')),
      );
    }
  }

  ///creating donation type checkboxes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate to ${widget.home['name']}'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('centres').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var centres = [];
              if (kDebugMode) {
                print(snapshot.data!.docs.first.toString());
              }

              for (var element in snapshot.data!.docs) {
                centres.add({
                  "name": element["name"],
                  "officerId": element["userId"],
                });
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select the type of donation you want to make:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CheckboxListTile(
                      title: const Text('Food'),
                      value: _foodChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _foodChecked = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Clothing'),
                      value: _clothingChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _clothingChecked = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Select the centre you will place your donation:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    for (var centre in centres)
                      RadioListTile(
                        title: Text(centre["name"]),
                        value: jsonEncode(centre),
                        groupValue: _selectedCentre,
                        onChanged: (value) {
                          setState(() {
                            _selectedCentre = value;
                          });
                        },
                      ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        onPressed: _submitDonation, child: const Text('Submit'))
                  ],
                ),
              );
            }

            return const LinearProgressIndicator();
          }),
    );
  }
}
