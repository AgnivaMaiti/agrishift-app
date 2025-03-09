import 'package:flutter/material.dart';

class GovernmentSchemesScreen extends StatelessWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double paddingValue = MediaQuery.of(context).size.width * 0.05;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Government Schemes',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SchemesList(),
          ],
        ),
      ),
    );
  }
}

class SchemesList extends StatelessWidget {
  const SchemesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) => SchemeCard(index: index),
    );
  }
}

class SchemeCard extends StatelessWidget {
  final int index;

  const SchemeCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final double paddingValue = MediaQuery.of(context).size.width * 0.04;
    final double borderRadiusValue = MediaQuery.of(context).size.width * 0.03;
    final Color iconColor = Color(0xFF147B2C);

    return Padding(
      padding: EdgeInsets.only(bottom: paddingValue),
      child: Container(
        padding: EdgeInsets.all(paddingValue),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.black26, spreadRadius: 2)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.policy, color: iconColor),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  'Scheme ${index + 1}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Text('Description of the government scheme goes here...',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Text(
              'Benefits:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            BenefitItem(
                text: 'Financial support up to ₹XX,XXX', iconColor: iconColor),
            BenefitItem(text: 'Technical assistance', iconColor: iconColor),
            BenefitItem(text: 'Equipment subsidies', iconColor: iconColor),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Download Guidelines',
                    style: TextStyle(color: Color(0xff147b2c)),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.045,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff147b2c)),
                    child: Center(
                      child: Text(
                        'Apply Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String text;
  final Color iconColor;

  const BenefitItem({super.key, required this.text, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width * 0.04;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: iconSize, color: iconColor),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Text(text),
        ],
      ),
    );
  }
}
