import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:agri/pages/job_search_screen.dart';
import 'package:agri/pages/government_schemes_screen.dart';
import 'package:agri/pages/marketplace_screen.dart';
import 'package:agri/pages/about_us.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D7C0F),
        elevation: 0,
        title: Text(
          languageProvider.translate('hello_farmers'),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(Icons.history, color: Colors.white),
          ),
          SizedBox(width: 8),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(context),
      body: _buildSelectedScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4D7C0F),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Color(0xFF4D7C0F)),
                ),
                SizedBox(height: 10),
                Text(
                  'Farmer Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(languageProvider.translate('profile')),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(languageProvider.translate('change_language')),
            onTap: () {
              Navigator.pop(context);
              _showLanguageDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(languageProvider.translate('about_us')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(languageProvider.translate('change_language')),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LanguageProvider.languageNames.length,
              itemBuilder: (BuildContext context, int index) {
                String langCode =
                    LanguageProvider.languageNames.keys.elementAt(index);
                String langName =
                    LanguageProvider.languageNames.values.elementAt(index);

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

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return CropRecommendationScreen();
      case 1:
        return JobSearchScreen();
      case 2:
        return GovernmentSchemesScreen();
      case 3:
        return MarketplaceScreen();
      default:
        return CropRecommendationScreen();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.crop),
          label: languageProvider.translate('crop_guide'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: languageProvider.translate('jobs'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.policy),
          label: languageProvider.translate('schemes'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: languageProvider.translate('market'),
        ),
      ],
    );
  }
}

class CropRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: const Color(0xFF4D7C0F),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(context),
                SizedBox(height: 20),
                WeatherCard(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.translate('crop_recommendations'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                CommoditiesGrid(),
                SizedBox(height: 24),
                Text(
                  languageProvider.translate('my_fields'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                FieldCard(),
                SizedBox(height: 20),
                Text(
                  languageProvider.translate('recommended_actions'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildRecommendedActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: languageProvider.translate('search_placeholder'),
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                suffixIcon: Icon(Icons.mic, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
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
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF4D7C0F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: Color(0xFF4D7C0F),
                  ),
                ),
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
                      Text(
                        'Description of recommended action for your crops',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Chandi Hills',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '+16°',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.cloud, color: Colors.white, size: 32),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WeatherDetail(
                    icon: Icons.thermostat,
                    value: '22°C',
                    label: languageProvider.translate('soil_temp'),
                  ),
                  SizedBox(height: 8),
                  WeatherDetail(
                    icon: Icons.water_drop,
                    value: '55%',
                    label: languageProvider.translate('humidity'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherDetail(
                icon: Icons.air,
                value: '5 m/s',
                label: languageProvider.translate('wind'),
              ),
              WeatherDetail(
                icon: Icons.water,
                value: '0 mm',
                label: languageProvider.translate('precipitation'),
              ),
              Column(
                children: [
                  Text(
                    '5:25 am',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    languageProvider.translate('sunrise'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '8:04 pm',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    languageProvider.translate('sunset'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const WeatherDetail({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class CommoditiesGrid extends StatelessWidget {
  final List<Map<String, String>> commodities = [
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Corn', 'icon': '🌽'},
    {'name': 'Grapes', 'icon': '🍇'},
    {'name': 'Potato', 'icon': '🥔'},
    {'name': 'Olive', 'icon': '🫒'},
    {'name': 'Tomato', 'icon': '🍅'},
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    // You might want to add translations for commodity names as well

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: commodities.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(
              commodities[index]['icon']!,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 4),
            Text(
              commodities[index]['name']!,
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}

class FieldCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/field.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
