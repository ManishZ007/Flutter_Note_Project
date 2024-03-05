import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_project/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Views
import 'package:my_project/views/Register_view.dart';
import 'package:my_project/views/email_verify_view.dart';
import 'package:my_project/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 58, 108, 183)),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) {
        return const LoginView();
      },
      '/register/': (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print("Email is Verified");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Text("Done");

          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
