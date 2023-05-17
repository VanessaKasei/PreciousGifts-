import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:precious_gifts/AboutUs/about_page.dart';
import 'package:precious_gifts/homePage/donate_page.dart';
import 'package:precious_gifts/DirectorsForm/directors_form.dart';
import 'donations_page.dart';

void main() {
  runApp(const MyApp());
}

class Homes extends StatefulWidget {
  const Homes({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomesState createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  final CollectionReference _referenceHomes =
      FirebaseFirestore.instance.collection('Homes');
  // ignore: unused_field
  late Stream<QuerySnapshot> _streamHomes;

  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _streamHomes = _referenceHomes.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children\'s Homes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _referenceHomes.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.active) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot document = documents[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: Text(data['name']),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(data['location']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("${data['population']} children"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("Directed by ${data['director']}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DonatePage(
                                        home: data,
                                        homeId: document.id,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Donate'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewDonationPage(homeId: document.id),
                                    ),
                                  );
                                },
                                child: const Text('View donation'),
                              )
                            ]),
                      ),
                      const SizedBox(height: 10),
                      if (index < documents.length - 1) const Divider(),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: (FirebaseAuth.instance.currentUser!.uid ==
              "7Q2Je9MwT1YSDZ590OweOYqKy4n2")
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DirectorsForm(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            FirebaseAuth.instance.signOut();
          }
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const aboutus(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'About Us',
            icon: Icon(Icons.info),
          ),
          BottomNavigationBarItem(
            label: 'Sign out',
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Children\'s Homes',
      home: Homes(),
    );
  }
}
