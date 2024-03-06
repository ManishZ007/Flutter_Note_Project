import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Routes
import 'package:my_project/constants/routes.dart';
//Dialog
import 'package:my_project/dialogs/dialogs.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              // exception handling
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/notes/',
                    (route) => false,
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "invalid-credential") {
                  // ignore: use_build_context_synchronously
                  showErrorDialog(context, 'user not found');
                }
              }
            },
            child: const Text("Login"),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not register yet! Register here!"),
          )
        ],
      ),
    );
  }
}
