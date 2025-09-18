import 'package:agro/pages/profile_page.dart';
import 'package:agro/pages/signin_page.dart';
import 'package:agro/pages/signup_page.dart';
import 'package:agro/providers/language_provider.dart';
import 'package:agro/providers/navprovider.dart';
import 'package:agro/providers/user_provider.dart';
import 'package:agro/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage('en');

  final userProvider = UserProvider();
  await userProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => languageProvider),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => userProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageProvider.locale,
      theme: ThemeData(
        primaryColor: Color(0xff01342C),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff01342C)),
        fontFamily: 'Poppins',
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xff01342C),
          selectedItemColor: Color(0xffFFF8F0),
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => SignIn(userType: 'farmer'),
        '/signup': (context) => SignUp(userType: 'farmer'),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
