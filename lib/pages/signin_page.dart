import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'signup_page.dart';
import 'farmer_home.dart';

class SignIn extends StatefulWidget {
  final String userType;

  const SignIn({super.key, required this.userType});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FarmerHome()),
      );
    }
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFF8F0),
        body: SingleChildScrollView(
          child: Column(children: [
            ClipPath(
              clipper: OvalAppBarClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                color: Color(0xff147b2c),
                child: AppBar(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FarmerHome(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return ScaleTransition(
                                  scale: Tween<double>(begin: 0.8, end: 1.0)
                                      .animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              fontFamily: 'Tenor Sans',
                              color: Colors.white),
                        ))
                  ],
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      'Login to your account',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Color(0xFFA6A6A6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: localizedStrings['email'] ?? 'Email',
                        labelStyle: TextStyle(color: Color(0xff147b2c)),
                        fillColor: Color(0xffE1E5E2),
                        filled: true,
                        focusColor: Color(0xff147b2c),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ), // Border color when focused
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xff147b2c),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        fillColor: Color(0xffE1E5E2),
                        filled: true,
                        suffixIconColor: Color(0xff147b2c),
                        labelText: localizedStrings['password'] ?? 'Password',
                        labelStyle: TextStyle(color: Color(0xff147b2c)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors
                                  .transparent), // Border color when focused
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff147b2c),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Circular shape
                          ),
                          activeColor: Color(0xff147b2c),
                          focusColor: Color(0xff147b2c),
                          value: isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              isChecked = newValue!;
                            });
                          },
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(color: Color(0xffBDB6B6)),
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    InkWell(
                      onTap: _handleSignIn,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.068,
                        decoration: BoxDecoration(
                            color: Color(0xff147b2c),
                            borderRadius: BorderRadius.circular(
                                (MediaQuery.of(context).size.height * 0.068) /
                                    2)),
                        child: Center(
                          child: Text(
                            localizedStrings['login'] ?? 'Login',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Color(0xff999999)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignUp(userType: widget.userType),
                              ),
                            );
                          },
                          child: Text(
                            localizedStrings['Sign Up'] ?? 'Sign Up',
                            style: TextStyle(
                                color: Color(0xFF147b2c),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF147b2c)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class OvalAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width / 2, size.height * 1.2, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
