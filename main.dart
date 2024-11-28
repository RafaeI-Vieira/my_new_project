import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_new_project/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_new_project/screens/home_screen.dart'; 
import 'package:my_new_project/screens/my_list_screen.dart';
import 'package:my_new_project/providers/movie_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await dotenv.load(fileName: "assets/env/.env"); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'Globoplay',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(), 
        routes: {
          '/home': (context) => HomeScreen(),  
          '/my_list_screen': (context) => MyListScreen(), 
        },
      ),
    );
  }
}
