import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:precious_gifts/imports/import.dart';

class ViewDonationPage extends StatelessWidget {
  final String homeId;

  const ViewDonationPage({Key? key, required this.homeId}) : super(key: key);

  void getData() async {
    FirebaseFirestore.instance
        .collection('centres')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if (kDebugMode) {
              print(documentSnapshot.data());
            }
          }
        } as FutureOr Function(QuerySnapshot<Map<String, dynamic>> value));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Donations'),
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.ramen_dining_rounded),
              child: Text("Food"),
            ),
            Tab(
              icon: Icon(Icons.checkroom_rounded),
              child: Text("Clothing"),
            ),
            Tab(
              icon: Icon(Icons.favorite_rounded),
              child: Text("My Donations"),
            ),
          ]),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('donations').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              Map<String, dynamic> data;

              List<Widget> foodDonationsList = [];
              List<Widget> clothingDonationsList = [];
              List<Widget> myDonationsList = [];

              for (QueryDocumentSnapshot document in documents) {
                data = document.data() as Map<String, dynamic>;
                var date = DateFormat('EEEE MMMM dd, yyyy')
                    .format((data['time'] as Timestamp).toDate());

                if (data['homeId'] == homeId) {
                  if (data['userId'] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    myDonationsList.add(ListTile(
                      title: Text(document.id),
                      leading: Column(
                        children: [
                          if (data['food'])
                            const Icon(Icons.ramen_dining_rounded),
                          if (data['clothing'])
                            const Icon(Icons.checkroom_rounded),
                        ],
                      ),
                      trailing: (data['userId'] ==
                                  FirebaseAuth.instance.currentUser!.uid &&
                              !data["received"])
                          ? IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("donations")
                                    .doc(document.id)
                                    .delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Donation record deleted"),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete_forever_rounded),
                            )
                          : null,
                      subtitle: Wrap(
                        direction: Axis.vertical,
                        children: [
                          (data['received'])
                              ? Text('received on $date')
                              : Text('pledged on $date'),
                          Text("center : ${data['center']}"),
                          Text(
                            'status :  ${data['received'] ? 'RECEIVED' : 'PENDING'}',
                          ),
                        ],
                      ),
                    ));
                  }

                  List<Widget> status = [
                    (data['received'])
                        ? Text('received on $date')
                        : Text('pledged on $date'),
                    (data['received'])
                        ? const Text('status : RECEIVED ')
                        : (data['officerId'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("donations")
                                      .doc(document.id)
                                      .update(
                                    {
                                      "received": true,
                                      "time": DateTime.now(),
                                    },
                                  );
                                },
                                icon: const Icon(Icons.check_rounded),
                                label: const Text("Mark as RECEIVED"),
                              )
                            : const Text('status : PENDING ')
                  ];

                  if (data['food']) {
                    foodDonationsList.add(
                      ListTile(
                        leading: const Icon(Icons.food_bank),
                        title: Text('Center: ${data['center']}'),
                        subtitle: Wrap(
                          direction: Axis.vertical,
                          children: [Text('id : ${document.id}'), ...status],
                        ),
                      ),
                    );
                  }
                  if (data['clothing']) {
                    clothingDonationsList.add(
                      ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text('Center: ${data['center']}'),
                        subtitle: Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text('id : ${document.id}'),
                            ...status,
                          ],
                        ),
                      ),
                    );
                  }
                }
              }

              return TabBarView(
                children: [
                  foodDonationsList.isNotEmpty
                      ? ListView(children: foodDonationsList)
                      : const Center(
                          child: Text('No food donations yet.'),
                        ),
                  clothingDonationsList.isNotEmpty
                      ? ListView(children: clothingDonationsList)
                      : const Center(
                          child: Text('No clothing donations yet.'),
                        ),
                  myDonationsList.isNotEmpty
                      ? ListView(children: myDonationsList)
                      : const Center(
                          child: Text('Nothing donated yet.'),
                        ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
