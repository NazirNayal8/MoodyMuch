import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moodymuch/model/UserModel.dart';
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
    return StreamProvider<AppUser>.value(
      value: AuthenticationService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoodyMuch App',
        theme: theme(),
        darkTheme: darktheme(),
        home: AuthenticationWrapper(),
        routes: routes,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    if (user != null) {
      return HomeScreen();
    }
    return SignInScreen();
  }
}