import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moodymuch/routes.dart';
import 'package:moodymuch/screens/home/home_screen.dart';
import 'package:moodymuch/screens/sign_in/sign_in_screen.dart';
import 'package:moodymuch/theme.dart';
import 'package:provider/provider.dart';
import 'helper/authentication_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoodyMuch App',
        theme: theme(),
        // home: SplashScreen(),
        // We use routeName so that we dont need to remember the name
        //initialRoute: SignInScreen.routeName,
        home: AuthenticationWrapper(),
        routes: routes,
      )
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomeScreen();
    }
    return SignInScreen();
  }
}