import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'pages/splash_screen.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/profile_page.dart';
import 'pages/offer_space_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Para Flutter Web: inicializar con opciones explícitas
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    // Para Android/iOS: usa configuración automática
    await Firebase.initializeApp();
  }

  runApp(const ParkAmigoApp());
}

class ParkAmigoApp extends StatelessWidget {
  const ParkAmigoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkAmigo',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => SplashScreen(),
        '/home': (_) => HomePage(),
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/profile': (_) => const ProfilePage(),
        '/offer_space': (_) => OfferSpacePage(),
      },
    );
  }
}
