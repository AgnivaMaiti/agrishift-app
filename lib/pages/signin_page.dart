import 'package:agro/Providers/language_provider.dart';
import 'package:agro/utils/transitions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';
import 'farmer_home.dart';
import 'package:agro/pages/farmer_main.dart';

class SignIn extends StatefulWidget {
  final String userType;

  const SignIn({super.key, required this.userType});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xff01342C),
        body: SingleChildScrollView(
          child: Column(
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
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        localizedStrings['login'] ?? 'Login',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: h * 0.05),
                      buildTextField(
                        localizedStrings['phone'] ?? "Phone",
                        localizedStrings['enter registered phone'] ??
                            "Enter registered phone number",
                        _phoneController,
                        TextInputType.phone,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return localizedStrings['please enter phone number'] ??
                                "Please enter phone number";
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return localizedStrings['please enter a valid phone number'] ??
                                "Please enter a valid phone number";
                          }
                          return null;
                        },
                        null,
                        null,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      buildTextField(
                        localizedStrings['password'] ?? "Password",
                        localizedStrings['enter password'] ??
                            "Enter your password",
                        _passwordController,
                        TextInputType.visiblePassword,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
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
                            localizedStrings['Keep me signed in'] ??
                                'Keep me signed in',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              localizedStrings['forgot password?'] ??
                                  "Forgot Password?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      InkWell(
                        onTap: _handleSignIn,
                        child: Container(
                          width: w * 0.6,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Color(0xff4EBE44),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              localizedStrings['login'] ?? 'Login',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.white,
                        height: 20,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
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
                                localizedStrings['google login'] ??
                                    'Log in with Google',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.015),
                      Row(
                        children: [
                          Text(
                            localizedStrings['not registered'] ??
                                "Not Registered yet?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                SlideTransitionRoute(
                                  page: SignUp(userType: widget.userType),
                                ),
                              );
                            },
                            child: Text(
                              localizedStrings['sign up'] ?? "Sign Up",
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType type,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
  ) {
    final double h = MediaQuery.of(context).size.height;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        SizedBox(height: h * 0.01),
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          keyboardType: type,
          obscureText: label == "Password" ? _obscurePassword : false,
          decoration: InputDecoration(
            suffixIcon:
                suffixIcon != null
                    ? IconButton(onPressed: onTap, icon: suffixIcon)
                    : null,
            hintText: localizedStrings[hint] ?? hint,
            fillColor: Color(0xffE1E5E2),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              ), // Border color when focused
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
