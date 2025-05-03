import 'package:agro/Providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgriculturalMarketPlace extends StatefulWidget {
  const AgriculturalMarketPlace({super.key});

  @override
  State<AgriculturalMarketPlace> createState() =>
      _AgriculturalMarketPlaceState();
}

class _AgriculturalMarketPlaceState extends State<AgriculturalMarketPlace> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          decoration: BoxDecoration(color: Color(0xff01342C)),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    localizedStrings['marketplace'] ??
                        "Agricultural Market Place",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        filled: true,

                        hintText: "Search",
                        hintStyle: TextStyle(color: Color(0xff1C4F47)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff1C4F47),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.mic_outlined,
                            color: Color(0xff1C4F47),
                          ),
                        ),
                        fillColor: Colors.white,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10 )],
                color: Colors.white,
                borderRadius:
                    index % 2 == 0
                        ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                        : BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
              ),
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRCZVKWKAUmqHUszu8_M3CoepdRNIXk9SvZQ&s",
                    ),
                    height: h * 0.1,
                  ),
                  Divider(thickness: 1, color: Colors.black),
                  Text(
                    "Product ${index + 1}",
                    style: TextStyle(color: Color(0xff01342C)),
                  ),
                  SizedBox(height: h * 0.01),
                  Row(
                    children: [
                      Text(
                        "Rs. 9047",
                        style: TextStyle(color: Color(0xff01342C)),
                      ),
                      Spacer(),
                      InkWell(
                        child: Container(
                          height: h * 0.03,
                          width: w * 0.2,
                          decoration: BoxDecoration(
                            color: Color(0xff4EBE44),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Buy Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
