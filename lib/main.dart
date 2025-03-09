import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:agri/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage('en');

  runApp(ChangeNotifierProvider(
    create: (_) => languageProvider,
    child: MyApp(),
  ));
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
        fontFamily: 'Tenor Sans',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      home: Splash(),
    );
  }
}
