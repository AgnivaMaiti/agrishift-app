// lib/pages/government_schemes_screen.dart
import 'package:flutter/material.dart';

class GovernmentSchemesScreen extends StatelessWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Government Schemes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.policy, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Scheme ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Description of the government scheme goes here...'),
            SizedBox(height: 12),
            Text(
              'Benefits:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            BenefitItem(text: 'Financial support up to ₹XX,XXX'),
            BenefitItem(text: 'Technical assistance'),
            BenefitItem(text: 'Equipment subsidies'),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle download guidelines
                  },
                  child: Text('Download Guidelines'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle apply now
                  },
                  child: Text('Apply Now'),
                ),
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

  const BenefitItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
