import 'package:flutter/material.dart';

class CommoditiesGrid extends StatelessWidget {
  final List<Map<String, String>> commodities = [
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Corn', 'icon': '🌽'},
    {'name': 'Grapes', 'icon': '🍇'},
    {'name': 'Potato', 'icon': '🥔'},
    {'name': 'Olive', 'icon': '🫒'},
    {'name': 'Tomato', 'icon': '🍅'},
  ];

  CommoditiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.height * 0.15,
              mainAxisSpacing: MediaQuery.of(context).size.width * 0.1,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.025,
            ),
            itemCount: commodities.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        commodities[index]['icon']!,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        commodities[index]['name']!,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
