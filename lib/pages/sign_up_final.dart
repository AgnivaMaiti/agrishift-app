import 'package:agro/Providers/language_provider.dart';
import 'package:agro/pages/farmer_main.dart';
import 'package:agro/pages/signin_page.dart';
import 'package:agro/utils/transitions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final String userType;

  const SignUp({super.key, required this.userType});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xff01342C),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SlideTransitionRoute(page: MainScreen()),
                    );
                  },
                  child: Text("Skip", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: h * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        buildTextField(
                          labelKey: localizedStrings['password'] ?? "Password",
                          hintKey: "Ex: johnDoe@123",
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onSuffixTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        buildTextField(
                          labelKey:
                              localizedStrings['confirm password'] ??
                              "Confirm Password",
                          hintKey: "Re-enter your password",
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onSuffixTap: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              semanticLabel:
                                  localizedStrings['Keep me signed in'] ??
                                  'Keep me signed in',

                              side: BorderSide(color: Colors.white, width: 2),
                              splashRadius: 20,
                              activeColor: Colors.white,

                              checkColor: Color(0xff01342C),
                              value: isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });
                              },
                            ),
                            Text(
                              localizedStrings['agree to tnc'] ??
                                  'I agree to Terms of Use and Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.01),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _handleSignUp,
                  child: Container(
                    width: w * 0.5,
                    height: h * 0.05,
                    decoration: BoxDecoration(
                      color: Color(0xff4EBE44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        localizedStrings['signup'] ?? 'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                  height: 30,
                  indent: 0,
                  endIndent: 0,
                ),
                InkWell(
                  child: Container(
                    width: w * 0.8,
                    height: h * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/images/google.png"),
                          height: h * 0.035,
                        ),
                        SizedBox(width: w * 0.02),
                        Text(
                          localizedStrings['google signup'] ??
                              'Sign up in with Google',
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      localizedStrings['existing user'] ??
                          "Already have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlideTransitionRoute(
                            page: SignIn(userType: widget.userType),
                          ),
                        );
                      },
                      child: Text(
                        localizedStrings['login'] ?? "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      localizedStrings['here'] ?? 'here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String labelKey,
    required String hintKey,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    final double h = MediaQuery.of(context).size.height;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    // Determine if the field is a password-related field
    bool isPasswordField =
        labelKey == 'password' || labelKey == 'confirm_password';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            localizedStrings[labelKey] ?? labelKey,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        SizedBox(height: h * 0.01),
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          keyboardType: keyboardType,
          obscureText:
              isPasswordField
                  ? (labelKey == 'password'
                      ? _obscurePassword
                      : _obscureConfirmPassword)
                  : false,
          decoration: InputDecoration(
            suffixIcon:
                suffixIcon != null
                    ? IconButton(onPressed: onSuffixTap, icon: suffixIcon)
                    : null,
            hintText: localizedStrings[hintKey] ?? hintKey,
            fillColor: const Color(0xffE1E5E2),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
