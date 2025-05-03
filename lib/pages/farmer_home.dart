import 'package:agro/Providers/language_provider.dart';
import 'package:agro/pages/commodities.dart';
import 'package:agro/pages/field_card.dart';
import 'package:agro/services/weather.dart';
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
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  localizedStrings['about_us'] ?? "About Us",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
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
                TextFormField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,

                    hintText: "Search",
                    hintStyle: TextStyle(color: Color(0xff1C4F47)),
                    prefixIcon: Icon(Icons.search, color: Color(0xff1C4F47)),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic_outlined, color: Color(0xff1C4F47)),
                    ),
                    fillColor: Colors.white,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
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
                        color: Color(0xff01342C),
                        border: Border.all(color: Color(0xff01342C), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: WeatherCard(),
                    ),
                  ],
                ),
                Text(
                  localizedStrings['crops_for_you'] ?? "Crops for you",
                  style: TextStyle(fontSize: 22, color: Color(0xff01342C)),
                ),
                SizedBox(height: h * 0.02),
                CommoditiesGrid(),
                SizedBox(height: h * 0.02),
                Text(
                  languageProvider.translate('my_fields'),
                  style: TextStyle(fontSize: 22, color: Color(0xff01342C)),
                ),
                SizedBox(height: h * 0.02),
                FieldCard(),
                SizedBox(height: h * 0.02),
                Text(
                  languageProvider.translate('recommended_actions'),
                  style: TextStyle(fontSize: 18, color: Color(0xff01342C)),
                ),
                SizedBox(height: h * 0.02),
                _buildRecommendedActions(context),
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

  Widget _buildRecommendedActions(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey[300]!),
              // borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Container(
                //   padding: EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: Color(0xFF4D7C0F).withAlpha(1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Icon(
                //     Icons.notifications_active,
                //     color: Color(0xFF4D7C0F),
                //   ),
                // ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Action ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // Text(
                      //   'Description of recommended action for your crops',
                      //   style: TextStyle(color: Colors.grey[600]),
                      // ),
                    ],
                  ),
                ),
                // Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}
