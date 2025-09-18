import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/language_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    if (!userProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizedStrings['profile'] ?? 'Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizedStrings['not logged in'] ?? 'Not logged in',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(localizedStrings['login'] ?? 'Login'),
              ),
            ],
          ),
        ),
      );
    }

    final user = userProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedStrings['profile'] ?? 'Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await userProvider.logout();
              // Navigate to home or login screen after logout
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: localizedStrings['logout'] ?? 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Profile picture placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            // User type chip
            Chip(
              label: Text(
                user.userType.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 30),
            // User details card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileInfoRow(
                      context,
                      Icons.person,
                      localizedStrings['name'] ?? 'Name',
                      user.name,
                    ),
                    Divider(),
                    _buildProfileInfoRow(
                      context,
                      Icons.email,
                      localizedStrings['email'] ?? 'Email',
                      user.email,
                    ),
                    Divider(),
                    _buildProfileInfoRow(
                      context,
                      Icons.phone,
                      localizedStrings['phone'] ?? 'Phone',
                      user.phone,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
