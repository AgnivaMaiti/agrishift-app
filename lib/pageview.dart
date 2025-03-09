import 'dart:async';
import 'package:agri/home.dart';
import 'package:flutter/material.dart';

class SlideshowScreen extends StatefulWidget {
  const SlideshowScreen({super.key});

  @override
  State<SlideshowScreen> createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/image1.jpg",
      "text": "Agricultural Marketplace",
      "subtext":
          "Buy and Sell farm produce directly to customers and businesses"
    },
    {
      "image": "assets/images/image2.jpg",
      "text": "Empowering Farmers with Technology",
      "subtext":
          "Join AgroVigya in revolutionizing through smart and sustainable practices"
    },
    {
      "image": "assets/images/image3.jpg",
      "text": "Why Choose AgroVigya?",
      "subtext":
          "Leverage AI powered tools to optimize yeild and boost productivity"
    },
    {
      "image": "assets/images/image4.jpg",
      "text": "Join the Farming Community",
      "subtext": "Buy and sell farm produce easily with smart farming tools."
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSlideShow();
  }

  void _startSlideShow() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        if (_currentIndex < slides.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(seconds: 1),
          curve: Curves.easeOutCirc,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(slides[index]["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (widget, animation) => FadeTransition(
                  opacity: animation,
                  child: widget,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slides[_currentIndex]["text"]!,
                      key: ValueKey(slides[_currentIndex]["text"]),
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withAlpha(7),
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      slides[_currentIndex]["subtext"]!,
                      key: ValueKey(slides[_currentIndex]["subtext"]),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withAlpha(7),
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Home(),
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
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.068,
                          decoration: BoxDecoration(
                              color: Color(0xff147b2c),
                              borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * 0.068) /
                                      2)),
                          child: Center(
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Tenor Sans',
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
