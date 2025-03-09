import 'package:agri/pages/crop_recom.dart';
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

class _FarmerHomeState extends State<FarmerHome> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isVisible = true;
  final ScrollController _scrollController = ScrollController();
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final currentPosition = _scrollController.position.pixels;

    if (currentPosition > _lastScrollPosition + 10) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else if (currentPosition < _lastScrollPosition - 10 ||
        currentPosition <= 0) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }

    _lastScrollPosition = currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF147b2c),
              elevation: 0,
              title: Text(
                languageProvider.translate('hello_farmers'),
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
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
            body: Expanded(child: _buildSelectedScreen()),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: _isVisible ? 80 : 0,
                child: _isVisible
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BottomAppBar(
                          notchMargin: 6.0,
                          elevation: 10.0,
                          color: Colors.black,
                          shape: CircularNotchedRectangle(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _selectedIndex == 0
                                        ? Icons.home
                                        : Icons.home_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      setState(() => _selectedIndex = 0),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _selectedIndex == 1
                                        ? Icons.work
                                        : Icons.work_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      setState(() => _selectedIndex = 1),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _selectedIndex == 2
                                        ? Icons.policy
                                        : Icons.policy_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      setState(() => _selectedIndex = 2),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _selectedIndex == 3
                                        ? Icons.store
                                        : Icons.store_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      setState(() => _selectedIndex = 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            )));
  }

  Widget _buildDrawer(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF147b2c),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_outline,
                      size: 35, color: Color(0xFF147b2c)),
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
            leading: Icon(Icons.person_outline),
            title: Text(languageProvider.translate('profile')),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text(languageProvider.translate('change_language')),
            onTap: () {
              Navigator.pop(context);
              _showLanguageDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
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
          content: SizedBox(
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
    Widget screen;

    switch (_selectedIndex) {
      case 0:
        screen = CropRecommendationScreen();
        break;
      case 1:
        screen = JobSearchScreen();
        break;
      case 2:
        screen = GovernmentSchemesScreen();
        break;
      case 3:
        screen = MarketplaceScreen();
        break;
      default:
        screen = CropRecommendationScreen();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          if (scrollNotification.scrollDelta != null) {
            if (scrollNotification.scrollDelta! > 0) {
              if (_isVisible) {
                setState(() {
                  _isVisible = false;
                });
              }
            } else if (scrollNotification.scrollDelta! < 0) {
              if (!_isVisible) {
                setState(() {
                  _isVisible = true;
                });
              }
            }
          }
        }
        return true;
      },
      child: screen,
    );
  }
}
