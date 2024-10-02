import 'package:exo4/services/UserAccountRoutes.dart';
import 'package:flutter/material.dart';

import '../model/UserAccount.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  final _formKey = GlobalKey<FormState>();

  String displayname = ""; // Initialize with empty string
  String login = ""; // Initialize with empty string
  String password = ""; // Initialize with empty string
  String repeatpassword = ""; // Initialize with empty string

  _signin() {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save(); // This will save the values from the form fields

    if (password != repeatpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords are not the same"),
        ),
      );
      return;
    }

    UserAccountRoutes()
        .insert(UserAccount(displayname: displayname, login: login, password: password))
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User account created"),
        ),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create user account"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Sign in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Display name",
                ),
                onSaved: (value) {
                  displayname = value ?? ""; // Safely assign the value
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a correct display name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Login",
                ),
                onSaved: (value) {
                  login = value ?? ""; // Safely assign the value
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a correct login';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                onSaved: (value) {
                  password = value ?? ""; // Safely assign the value
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a correct password';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Repeat password",
                ),
                obscureText: true,
                onSaved: (value) {
                  repeatpassword = value ?? ""; // Safely assign the value
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please repeat the password';
                  }
                  return null;
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signin,
                  child: const Text("Sign in"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
