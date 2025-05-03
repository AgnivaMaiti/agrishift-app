import 'package:agro/Providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({super.key});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
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
                    localizedStrings['find jobs'] ?? "Find Jobs",
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  child: Container(
                    height: h * 0.05,
                    width: w * 0.2,
                    decoration: BoxDecoration(
                      color: Color(0xff4EBE44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Mumbai",
                        style: TextStyle(color: Color(0xff01342C)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.05),
                InkWell(
                  child: Container(
                    height: h * 0.05,
                    width: w * 0.2,
                    decoration: BoxDecoration(
                      color: Color(0xff4EBE44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Pune",
                        style: TextStyle(color: Color(0xff01342C)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: Colors.black26),
                      ],
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
                    child: Row(
                      children: [
                        Image(
                          image: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRCZVKWKAUmqHUszu8_M3CoepdRNIXk9SvZQ&s",
                          ),
                          height: h * 0.06,
                        ),
                        SizedBox(width: w * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Job ${index + 1}",
                              style: TextStyle(
                                color: Color(0xff01342C),
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(height: h * 0.02),
                            Text(
                              "Description.....",
                              style: TextStyle(color: Color(0xff01342C)),
                            ),
                            SizedBox(height: h * 0.02),
                            Text(
                              "line 2",
                              style: TextStyle(color: Color(0xff01342C)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
