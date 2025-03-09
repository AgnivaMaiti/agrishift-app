import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agri/Providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? weatherData;
  String location = 'Loading...';

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

  IconData _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return Icons.cloud;

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
        return Icons.grain;
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
        color: Colors.white.withAlpha(30),
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
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
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
                  controller.clear();
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