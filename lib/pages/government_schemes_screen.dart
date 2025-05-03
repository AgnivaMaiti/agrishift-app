import 'dart:convert';
import 'package:agro/Providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GovernmentSchemes extends StatefulWidget {
  const GovernmentSchemes({super.key});

  @override
  State<GovernmentSchemes> createState() => _GovernmentSchemesState();
}

class _GovernmentSchemesState extends State<GovernmentSchemes> {
  List<Map<String, String>> schemes = [];

  @override
  void initState() {
    super.initState();
    loadSchemes();
  }

  Future<void> loadSchemes() async {
    final String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/govt_schemes.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      schemes = jsonData.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          decoration: const BoxDecoration(color: Color(0xff01342C)),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    localizedStrings['government schemes'] ??
                        "Government Schemes",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.white),
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
                        hintStyle: const TextStyle(color: Color(0xff1C4F47)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff1C4F47),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
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
                    icon: const Icon(
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
      body:
          schemes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : buildSchemeListView(schemes),
    );
  }

  Widget buildSchemeListView(List<Map<String, String>> schemes) {
    final double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: schemes.length,
      itemBuilder: (context, index) {
        final scheme = schemes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          elevation: 2,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              trailing: SizedBox.shrink(),
              title: Expanded(
                child: Text(
                  scheme['Scheme Name'] ?? 'Unknown Scheme',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              subtitle: Row(
                children: [
                  SizedBox(width: w * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Type: ${scheme['Scheme Type'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Income Level: ${scheme['Income Level'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'States: ${scheme['States Eligible'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Duration', scheme['Duration'] ?? 'N/A'),
                      _buildDetailRow('Job Type', scheme['Job Type'] ?? 'N/A'),
                      _buildDetailRow(
                        'Target Audience',
                        scheme['Target Audience'] ?? 'N/A',
                      ),
                      _buildDetailRow('Location', scheme['Location'] ?? 'N/A'),
                      _buildDetailRow(
                        'Scheme Status',
                        scheme['Scheme Status'] ?? 'N/A',
                      ),
                      _buildDetailRow('Ministry', scheme['Ministry'] ?? 'N/A'),
                      _buildDetailRow(
                        'Application Process',
                        scheme['Application Process'] ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Target Age',
                        scheme['Target Age'] ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Target Gender',
                        scheme['Target Gender'] ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Target Occupation',
                        scheme['Target Occupation'] ?? 'N/A',
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Download Brochure",
                        style: TextStyle(color: Color(0xff4EBE44)),
                      ),
                    ),
                    SizedBox(width: w * 0.2),
                    InkWell(
                      child: Container(
                        height: h * 0.03,
                        width: w * 0.28,
                        decoration: BoxDecoration(
                          color: Color(0xff4EBE44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Apply Now",
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
