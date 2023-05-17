import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home {
  final String name;
  final int population;
  final String location;
  final String director;

  Home(
      {required this.name,
      required this.population,
      required this.location,
      required this.director});
}

class DirectorsForm extends StatefulWidget {
  const DirectorsForm({super.key});

  @override
  _DirectorsFormState createState() => _DirectorsFormState();
}

class _DirectorsFormState extends State<DirectorsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _populationController = TextEditingController();
  final _locationController = TextEditingController();
  final _directorController = TextEditingController();

  final CollectionReference _homesRef =
      FirebaseFirestore.instance.collection('Homes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Homes'),
      ),
      body: Column(children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the Children\'s Home';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _populationController,
                decoration: const InputDecoration(labelText: 'Population'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the population';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: 'Director'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the nname of the director';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _homesRef.add({
                      'name': _nameController.text,
                      'population': int.parse(_populationController.text),
                      'location': _locationController.text,
                      'director': _directorController.text,
                    }).then((value) => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                            content: Text('Home added successfully'))));
                    _nameController.clear();
                    _populationController.clear();
                    _locationController.clear();
                    _directorController.clear();
                  }
                },
                child: const Text('Add Home'),
              ),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _homesRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Home> homes = [];
              for (var doc in snapshot.data!.docs) {
                homes.add(Home(
                  name: doc['name'],
                  population: doc['population'],
                  location: doc['location'],
                  director: doc['director'],
                ));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: homes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(homes[index].name),
                      subtitle: Text('Population: ${homes[index].population}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _homesRef.doc(snapshot.data!.docs[index].id).delete();
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('An error occurred');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ]),
    );
  }
}
