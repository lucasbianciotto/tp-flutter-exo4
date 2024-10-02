import 'package:exo4/pages/AddCarPage.dart';
import 'package:exo4/pages/LoginPage.dart';
import 'package:exo4/services/CarAPI.dart';
import 'package:exo4/services/LoginState.dart';
import 'package:exo4/services/UserAccountRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/Car.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LoginState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer<LoginState>(
        builder: (context, loginState, child) {
          if (loginState.connected()) {
            return const MyHomePage(title: "Vehicles");
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Car>>? cars;

  initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      LoginState loginState = Provider.of<LoginState>(context, listen: false);
      String token = loginState.getToken()!;

      // Rafraîchir le token
      String newToken = await UserAccountRoutes.refreshToken(token);

      // Mettre à jour le token dans l'état de connexion
      loginState.setToken(newToken);

      // Récupérer les voitures avec le nouveau token
      List<Car> carList = await CarAPI.getAll(newToken);

      // Mettre à jour l'état avec la liste des voitures
      setState(() {
        cars = Future.value(carList);
      });
    } catch (e) {
      print("Erreur lors du chargement des voitures: $e");
      setState(() {
        cars = Future.error("Erreur lors du chargement des voitures");
      });
    }
  }

  _deleteCar(int id) async {
    LoginState loginState = Provider.of<LoginState>(context, listen: false);
    String token = loginState.getToken()!;

    final newToken = await UserAccountRoutes.refreshToken(token);

    Provider.of<LoginState>(context, listen: false).setToken(newToken);

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Delete car'),
        content: const Text('Are you sure you want to delete this car?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              CarAPI.deleteCar(newToken!, id).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Car deleted"),
                  ),
                );
                Navigator.pop(context);
                setState(() {
                  cars = CarAPI.getAll(newToken);
                });
              }).catchError((error) {
                print(error);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to delete car"),
                  ),
                );
              });
            },
            child: const Text('Delete'),
          ),
        ],
      );
    });
  }

  _editCar(Car car) {
    final _formKey = GlobalKey<FormState>();

    Car newCar = Car(
      id: car.id,
      make: car.make,
      model: car.model,
      isrunning: car.isrunning,
      price: car.price,
      builddate: car.builddate,
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit car'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  initialValue: newCar.make,
                  decoration: const InputDecoration(labelText: 'Make'),
                  onSaved: (value) {
                    newCar.make = value!;
                  },
                ),
                TextFormField(
                  initialValue: newCar.model,
                  decoration: const InputDecoration(labelText: 'Model'),
                  onSaved: (value) {
                    newCar.model = value!;
                  },
                ),
                FormField(
                  builder: (FormFieldState<bool> state) {
                    return Row(
                      children: [
                        const Text('Is running: '),
                        Switch(
                          value: newCar.isrunning,
                          onChanged: (value) {
                            state.didChange(value);
                            newCar.isrunning = value!;
                          },
                        ),
                      ],
                    );
                  },
                ),
                TextFormField(
                  initialValue: newCar.price.toStringAsFixed(2),
                  decoration: const InputDecoration(labelText: 'Price'),
                  onSaved: (value) {
                    newCar.price = double.parse(value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                _formKey.currentState!.save();

                LoginState loginState = Provider.of<LoginState>(context, listen: false);
                String token = loginState.getToken()!;

                final newToken = await UserAccountRoutes.refreshToken(token);

                Provider.of<LoginState>(context, listen: false).setToken(newToken);

                CarAPI.editCar(newToken, newCar).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Car updated"),
                    ),
                  );
                  Navigator.pop(context);
                  setState(() {
                    cars = CarAPI.getAll(newToken);
                  });
                }).catchError((error) {
                  print(error);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to update car"),
                    ),
                  );
                });

              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add a car'),
              onTap: () async {
                Car? newCar = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCarPage()));

                if (newCar != null) {
                  setState(() {
                    _loadCars();
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                final loginState = Provider.of<LoginState>(context, listen: false);
                loginState.disconnect();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<Car>>(
                future: cars,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Car car = snapshot.data![index];
                        return ListTile(
                          title: Text(car.make + ' ' + car.model),
                          subtitle: Text('${car.price.toStringAsFixed(2)}€'),
                          leading: Icon(car.isrunning ? Icons.directions_car : Icons.directions_car_filled, color: car.isrunning ? Colors.green : Colors.red),
                          trailing: SizedBox(
                            width: 120, // Définir une largeur fixe pour la ligne
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editCar(car);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteCar(car.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
