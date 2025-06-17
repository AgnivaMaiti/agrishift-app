import 'package:agro/pages/about_us.dart';
import 'package:agro/pages/news.dart';
import 'package:agro/providers/language_provider.dart';
import 'package:agro/services/weather.dart';
import 'package:agro/utils/transitions.dart';
import 'package:agro/widgets/crop_recommendation_widget.dart';
import 'package:agro/widgets/labor_estimation_widget.dart';
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
        endDrawer: SafeArea(
          child: Drawer(
            backgroundColor: Color(0xff01342C),
            child: Column(
              children: [
                // Drawer Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4EBE44).withAlpha(28),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF4EBE44).withAlpha(52),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizedStrings['hello farmer'] ??
                                    "Hello Farmer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Welcome back!",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    children: [
                      _buildDrawerItem(
                        icon: Icons.person_outline,
                        title: localizedStrings['profile'] ?? "Profile",
                        onTap: () {},
                      ),
                      _buildDrawerItem(
                        icon: Icons.info_outline,
                        title: localizedStrings['about_us'] ?? "About Us",
                        onTap: () {
                          Navigator.push(
                            context,
                            SlideTransitionRoute(page: AboutUsScreen()),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.language,
                        title:
                            localizedStrings['change lang'] ??
                            "Change Language",
                        onTap: () {
                          _showLanguageDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xffFFF8F0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 15),
            decoration: BoxDecoration(color: Color(0xff01342C)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizedStrings['hello farmer'] ?? "Hello Farmer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Let's grow together 🌱",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF4EBE44).withAlpha(51),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xFF4EBE44).withAlpha(78),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xFFFFF8F0),
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                // Weather Section
                _buildSectionCard(
                  title: localizedStrings['weather'] ?? "Weather",
                  icon: Icons.wb_sunny_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: WeatherCard(),
                  ),
                ),

                SizedBox(height: h * 0.03),

                _buildSectionCard(
                  title: localizedStrings['crops_for_you'] ?? "Crops for you",
                  icon: Icons.agriculture_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CropRecommendationWidget(),
                  ),
                ),

                SizedBox(height: h * 0.03),

                // Labor Estimation Section
                _buildSectionCard(
                  title: languageProvider.translate('labour_estimation'),
                  icon: Icons.groups_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: LaborEstimationWidget(),
                  ),
                ),

                SizedBox(height: h * 0.03),

                // News Section
                _buildSectionCard(
                  title: "Latest News",
                  icon: Icons.newspaper_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: NewsWidget(),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xff01342C).withAlpha(13),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Color(0xff01342C), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff01342C),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF4EBE44).withAlpha(51),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xff01342C).withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.language, color: Color(0xff01342C), size: 24),
              ),
              SizedBox(width: 12),
              Text(
                languageProvider.translate('change_language'),
                style: TextStyle(
                  color: Color(0xff01342C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFF8F0),
                  ),
                  child: ListTile(
                    title: Text(
                      langName,
                      style: TextStyle(
                        color: Color(0xff01342C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF4EBE44),
                      size: 20,
                    ),
                    onTap: () {
                      languageProvider.loadLanguage(langCode);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
