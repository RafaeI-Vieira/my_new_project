import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_new_project/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_new_project/screens/home_screen.dart'; // Ajuste o caminho
import 'package:my_new_project/screens/my_list_screen.dart'; // Importe a tela "MyListScreen"
import 'package:my_new_project/providers/movie_provider.dart'; // Ajuste o caminho

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja inicializado antes de rodar o app
  
  // Carregar o arquivo .env a partir do diretório correto
  await dotenv.load(fileName: "assets/env/.env"); // Especifica o caminho correto
  
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
        home: SplashScreen(), // Tela inicial
        routes: {
          '/home': (context) => HomeScreen(),  
          '/my_list_screen': (context) => MyListScreen(), 
        },
      ),
    );
  }
}
