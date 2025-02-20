import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LanguageProvider.languageNames.length,
              itemBuilder: (BuildContext context, int index) {
                String langCode =
                    LanguageProvider.languageNames.keys.elementAt(index);
                String langName = LanguageProvider.languageNames[langCode]!;
                return ListTile(
                  title: Text(langName),
                  onTap: () {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .loadLanguage(langCode);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: Color(0xffFFF8F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Language selector at top right
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: _showLanguageDialog,
                  icon: Icon(Icons.language, size: 20),
                  label: Text(languageProvider.getCurrentLanguageName()),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
              ),

              // Logo
              const SizedBox(height: 40),
              Text(
                'AGROVIGYA',
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF2D6A4F),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 80),

              // User and Employer buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // User Column
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D6A4F),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(localizedStrings['user'] ?? 'User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D6A4F),
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Employer Column
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D6A4F),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(localizedStrings['employer'] ?? 'Employer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D6A4F),
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                      localizedStrings['discover_more'] ?? 'Discover more'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4A373),
                    foregroundColor: Colors.black,
                    minimumSize: Size(200, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
