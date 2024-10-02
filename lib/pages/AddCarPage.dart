import 'package:exo4/model/Car.dart';
import 'package:exo4/services/CarAPI.dart';
import 'package:exo4/services/LoginState.dart';
import 'package:exo4/services/UserAccountRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();

  String make = "";
  String model = "";
  bool isrunning = false;
  double price = 0;
  DateTime builddate = DateTime.now();
  int useraccount_id = 0;

  _addCar() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save(); // Save form fields

    var newCar = Car(
      make: make,
      model: model,
      isrunning: isrunning,
      price: price,
      builddate: builddate,
    );

    final token = Provider.of<LoginState>(context, listen: false).getToken();
    final newToken = await UserAccountRoutes.refreshToken(token!);

    Provider.of<LoginState>(context, listen: false).setToken(newToken);

    try {
      Car addedCar = await CarAPI.addCar(newToken, newCar);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Car added"),
        ),
      );

      _formKey.currentState!.reset();
      Navigator.pop(context, addedCar);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add car"),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add a car"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Make"),
                onSaved: (value) => make = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a make";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Model"),
                onSaved: (value) => model = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a model";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.parse(value!),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a price";
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text("Is running"),
                value: isrunning,
                onChanged: (value) {
                  setState(() {
                    isrunning = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _addCar,
                child: const Text("Add car"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
