import 'package:exo4/model/AuthenticationResult.dart';
import 'package:exo4/model/UserAccount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/LoginState.dart';
import '../services/UserAccountRoutes.dart';
import 'SigninPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String login = "";
  String password = "";

  bool processLogin = false;
  bool loginError = false;

  final _formKey = GlobalKey<FormState>();

  _dologin() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      processLogin = true;
      loginError = false;
    });

    AuthenticationResult success = await UserAccountRoutes().authenticate(login, password);

    setState(() {
      processLogin = false;
      loginError = success == null;
    });

    if (success != null) {
      final loginState = Provider.of<LoginState>(context, listen: false);
      loginState.setUser(UserAccount(displayname: success.displayname, login: success.login));
      loginState.setToken(success.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Cars",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Login",
                ),
                onSaved: (value) {
                  login = value ?? ""; // Save the login value
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
                  password = value ?? ""; // Save the password value
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a correct password';
                  }
                  return null;
                },
              ),
              if (loginError)
                const Text(
                  "Login or password incorrect",
                  style: TextStyle(color: Colors.red),
                ),
              if (processLogin)
                const CircularProgressIndicator(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: processLogin ? null : _dologin,
                  child: const Text("Log in"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signinpage(),
                      ),
                    );
                  },
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
