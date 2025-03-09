import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:agri/pages/signin_page.dart';

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
          insetPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.2),
          title: Text('Select Language'),
          content: SizedBox(
              width: double.minPositive,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                    mainAxisSpacing: MediaQuery.of(context).size.height * 0.01),
                itemBuilder: (context, index) {
                  String langCode =
                      LanguageProvider.languageNames.keys.elementAt(index);
                  String langName = LanguageProvider.languageNames[langCode]!;
                  return InkWell(
                      onTap: () {
                        Provider.of<LanguageProvider>(context, listen: false)
                            .loadLanguage(langCode);
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            langName,
                            style: TextStyle(fontSize: 20),
                          ))));
                },
                itemCount: LanguageProvider.languageNames.length,
              )),
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
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: _showLanguageDialog,
                  icon: Icon(
                    Icons.language,
                    size: 20,
                    color: Color(0xff147B2C),
                  ),
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
                  color: Color(0xFF147B2C),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 80),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(userType: 'employer'),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF147B2C),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              color: Color(0xff147B2C),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                              child: Text(
                            localizedStrings['user'] ?? 'User',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(userType: 'employer'),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF147B2C),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              color: Color(0xff147B2C),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                              child: Text(
                            localizedStrings['employer'] ?? 'Employer',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4A373),
                    foregroundColor: Colors.black,
                    minimumSize: Size(200, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                      localizedStrings['discover_more'] ?? 'Discover more'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
