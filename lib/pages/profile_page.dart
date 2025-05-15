import 'package:agro/Providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  
  bool _isEditing = false;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _locationController = TextEditingController();
    
    // Load user data
    _loadUserData();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        _nameController.text = prefs.getString('user_name') ?? 'John Doe';
        _phoneController.text = prefs.getString('user_phone') ?? '+91 9876543210';
        _emailController.text = prefs.getString('user_email') ?? 'user@example.com';
        _locationController.text = prefs.getString('user_location') ?? 'New Delhi, India';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('user_name', _nameController.text);
      await prefs.setString('user_phone', _phoneController.text);
      await prefs.setString('user_email', _emailController.text);
      await prefs.setString('user_location', _locationController.text);
      
      setState(() {
        _isEditing = false;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error saving user data: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final primaryColor = Color(0xff01342C);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          languageProvider.translate('profile') ?? 'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isEditing) {
                _saveUserData();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header
                  Container(
                    color: primaryColor,
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _nameController.text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _emailController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Profile form
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                            title: languageProvider.translate('personal_information') ?? 
                                'Personal Information',
                          ),
                          SizedBox(height: 16),
                          
                          // Name field
                          ProfileField(
                            label: languageProvider.translate('full_name') ?? 'Full Name',
                            controller: _nameController,
                            icon: Icons.person,
                            isEditing: _isEditing,
                            validator: (value) => value!.isEmpty ? 
                                'Name cannot be empty' : null,
                          ),
                          SizedBox(height: 16),
                          
                          // Phone field
                          ProfileField(
                            label: languageProvider.translate('phone') ?? 'Phone Number',
                            controller: _phoneController,
                            icon: Icons.phone,
                            isEditing: _isEditing,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone number cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Email field
                          ProfileField(
                            label: languageProvider.translate('email') ?? 'Email',
                            controller: _emailController,
                            icon: Icons.email,
                            isEditing: _isEditing,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email cannot be empty';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Location field
                          ProfileField(
                            label: languageProvider.translate('location') ?? 'Location',
                            controller: _locationController,
                            icon: Icons.location_on,
                            isEditing: _isEditing,
                            validator: (value) => null,
                          ),
                          
                          SizedBox(height: 32),
                          
                          // App settings section
                          SectionTitle(
                            title: languageProvider.translate('app_settings') ?? 
                                'App Settings',
                          ),
                          SizedBox(height: 16),
                          
                          // Language setting
                          ListTile(
                            leading: Icon(Icons.language, color: primaryColor),
                            title: Text(
                              languageProvider.translate('change_language') ?? 
                                  'Change Language',
                            ),
                            subtitle: Text(
                              languageProvider.getCurrentLanguageName(),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              _showLanguageDialog(context);
                            },
                          ),
                          
                          // Notifications setting
                          SwitchListTile(
                            secondary: Icon(Icons.notifications, color: primaryColor),
                            title: Text(
                              languageProvider.translate('notifications') ?? 
                                  'Notifications',
                            ),
                            value: true,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              // TODO: Implement notifications toggle
                            },
                          ),
                          
                          SizedBox(height: 32),
                          
                          // Logout button
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement logout functionality
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.logout),
                              label: Text(
                                languageProvider.translate('logout') ?? 'Logout',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
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

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff01342C),
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 50,
          height: 2,
          color: Color(0xff01342C),
        ),
      ],
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isEditing;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.isEditing,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: Color(0xff01342C)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xff01342C), width: 2),
              ),
            ),
            keyboardType: keyboardType,
            validator: validator,
          )
        : ListTile(
            leading: Icon(icon, color: Color(0xff01342C)),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            subtitle: Text(
              controller.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }
}