import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agro/Providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  List articles = [];
  bool isLoading = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    final DateTime now = DateTime.now();
    final DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
    final String fromDate = sevenDaysAgo.toIso8601String().split('T')[0];

    final String url =
        'https://newsapi.org/v2/everything?q=Indian%20Agriculture%20and%20Farming&from=$fromDate&sortBy=relevancy&apiKey=68c5396380de4acb9a9b01637cca249c';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          articles = data['articles'].take(5).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Failed to load articles.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: isLoading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            )
          : errorMsg.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      errorMsg,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text(
                              article['title'] ?? 'No title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  article['source']['name'] ?? 'Unknown Source',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                if (article['description'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      article['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () async {
                              final url = article['url'];
                              if (url != null) {
                                try {
                                  await launchUrl(Uri.parse(url));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        languageProvider.translate('could_not_launch_url') ?? 
                                        'Could not launch URL',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}