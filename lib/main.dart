import 'package:flutter/material.dart';
import 'package:leysco/screens/Homepage.dart';
import 'package:leysco/screens/LoginScreen.dart';
import 'package:leysco/screens/RegisterScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure SharedPreferences is initialized
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');

  runApp(MyApp(initialRoute: authToken != null ? '/home' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute, // Set initial route dynamically based on authToken
      routes: {
        '/': (context) => LoginScreen(), // Define '/' route to LoginScreen
        '/register': (context) => RegisterScreen(), // Define '/register' route to RegisterScreen
        '/home': (context) => HomePage(), // Define '/home' route to HomePage
      },
    );
  }
}
