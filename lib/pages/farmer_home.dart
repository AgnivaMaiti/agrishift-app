import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:agri/pages/job_search_screen.dart';
import 'package:agri/pages/government_schemes_screen.dart';
import 'package:agri/pages/marketplace_screen.dart';
import 'package:agri/pages/about_us.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class WeatherCard extends StatefulWidget {
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? weatherData;
  String location = 'Loading...';

  // OpenWeatherMap API key - Replace with your own key
  final String apiKey = 'bd5e378503939ddaee76f12ad7a97608';

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocation = prefs.getString('weather_location');

      if (savedLocation != null && savedLocation.isNotEmpty) {
        fetchWeatherByCity(savedLocation);
      } else {
        _getCurrentLocation();
      }
    } catch (e) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permission denied';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied';
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      fetchWeatherByCoordinates(position.latitude, position.longitude);

      // Get location name from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String cityName = place.locality ?? '';
        if (cityName.isNotEmpty) {
          setState(() {
            location = cityName;
          });

          // Save location
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('weather_location', cityName);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error getting location: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          location = weatherData?['name'] ?? city;
          isLoading = false;

          // Save location
          _saveLocation(city);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          location = weatherData?['name'] ?? 'Unknown';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _saveLocation(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_location', city);
  }

  // Get weather icon based on condition code
  IconData _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return Icons.cloud;

    // First digit of the code determines the main weather category
    switch (iconCode.substring(0, 2)) {
      case '01':
        return Icons.wb_sunny; // clear sky
      case '02':
        return Icons.cloud; // few clouds - using cloud instead of partly_sunny
      case '03':
        return Icons.cloud; // scattered clouds
      case '04':
        return Icons.cloud_queue; // broken clouds
      case '09':
        return Icons.grain; // shower rain
      case '10':
        return Icons.beach_access; // rain
      case '11':
        return Icons.flash_on; // thunderstorm
      case '13':
        return Icons.ac_unit; // snow
      case '50':
        return Icons.blur_on; // mist
      default:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading
          ?
          // Loading state
          Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : errorMessage.isNotEmpty
              ?
              // Error state
              Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 30),
                      SizedBox(height: 8),
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _getCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF4D7C0F),
                        ),
                        child: Text(languageProvider.translate('retry')),
                      ),
                    ],
                  ),
                )
              :
              // Weather data state
              Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  location,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '${weatherData?['main']?['temp']?.toStringAsFixed(1) ?? '0'}°',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                    _getWeatherIcon(
                                        weatherData?['weather']?[0]?['icon']),
                                    color: Colors.white,
                                    size: 32),
                              ],
                            ),
                            Text(
                              weatherData?['weather']?[0]?['description'] ?? '',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildWeatherDetail(
                              icon: Icons.thermostat,
                              value:
                                  '${weatherData?['main']?['feels_like']?.toStringAsFixed(1) ?? '0'}°C',
                              label: languageProvider.translate('feels_like'),
                            ),
                            SizedBox(height: 8),
                            _buildWeatherDetail(
                              icon: Icons.water_drop,
                              value:
                                  '${weatherData?['main']?['humidity'] ?? '0'}%',
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
                        _buildWeatherDetail(
                          icon: Icons.air,
                          value: '${weatherData?['wind']?['speed'] ?? '0'} m/s',
                          label: languageProvider.translate('wind'),
                        ),
                        _buildWeatherDetail(
                          icon: Icons.compress,
                          value:
                              '${weatherData?['main']?['pressure'] ?? '0'} hPa',
                          label: languageProvider.translate('pressure'),
                        ),
                        Column(
                          children: [
                            Text(
                              _formatTime(weatherData?['sys']?['sunrise'] ?? 0),
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
                              _formatTime(weatherData?['sys']?['sunset'] ?? 0),
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
                    SizedBox(height: 12),
                    _buildSearchBar(context),
                  ],
                ),
    );
  }

  String _formatTime(int timestamp) {
    if (timestamp == 0) return '00:00';
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String value,
    required String label,
  }) {
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

  Widget _buildSearchBar(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final TextEditingController _controller = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: languageProvider.translate('search_location'),
                hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchWeatherByCity(value);
                  _controller.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.my_location, color: Colors.white, size: 16),
            onPressed: _getCurrentLocation,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
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
