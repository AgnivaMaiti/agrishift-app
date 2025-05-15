import 'package:agro/Providers/language_provider.dart';
import 'package:agro/pages/field_card.dart';
import 'package:agro/pages/about_us.dart'; 
import 'package:agro/pages/profile_page.dart'; 
import 'package:agro/services/weather.dart';
import 'package:agro/widgets/crop_recommendation_widget.dart';
import 'package:agro/widgets/labor_estimation_widget.dart';
import 'package:agro/widgets/news_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    final double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          backgroundColor: Color(0xff01342C),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text(
                  localizedStrings['profile'] ?? "Profile",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  localizedStrings['about_us'] ?? "About Us",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  localizedStrings['change lang'] ?? "Change Language",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xffFFF8F0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            decoration: BoxDecoration(color: Color(0xff01342C)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      localizedStrings['hello farmer'] ?? "Hello Farmer",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      icon: Icon(Icons.menu, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedStrings['weather'] ?? "Weather",
                      style: TextStyle(color: Color(0xff01342C), fontSize: 22),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: WeatherCard(),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.02),
                Text(
                  localizedStrings['crops_for_you'] ?? "Crops for you",
                  style: TextStyle(fontSize: 22, color: Color(0xff01342C)),
                ),
                CropRecommendationWidget(),
                SizedBox(height: h * 0.02),
                Text(
                  languageProvider.translate('labour_estimation'),
                  style: TextStyle(fontSize: 22, color: Color(0xff01342C)),
                ),
                LaborEstimationWidget(),
                SizedBox(height: h * 0.02),

                Text(
                  languageProvider.translate('agriculture_news') ?? "Agriculture News",
                  style: TextStyle(fontSize: 22, color: Color(0xff01342C)),
                ),
                NewsWidget(),
                SizedBox(height: h * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(languageProvider.translate('change_language')),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LanguageProvider.languageNames.length,
              itemBuilder: (BuildContext context, int index) {
                String langCode = LanguageProvider.languageNames.keys.elementAt(
                  index,
                );
                String langName = LanguageProvider.languageNames.values
                    .elementAt(index);

                return ListTile(
                  title: Text(langName),
                  onTap: () {
                    languageProvider.loadLanguage(langCode);
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
}
