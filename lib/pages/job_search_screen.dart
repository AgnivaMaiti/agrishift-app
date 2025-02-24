// lib/pages/job_search_screen.dart
import 'package:flutter/material.dart';

class JobSearchScreen extends StatelessWidget {
  const JobSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Jobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            JobsList(),
          ],
        ),
      ),
    );
  }
}

class JobsList extends StatelessWidget {
  const JobsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => JobCard(index: index),
    );
  }
}

class JobCard extends StatelessWidget {
  final int index;

  const JobCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm Worker Position ${index + 1}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            JobDetail(icon: Icons.location_on, text: 'Farm Location'),
            JobDetail(icon: Icons.money, text: 'Salary: \$XX,XXX'),
            JobDetail(icon: Icons.work_history, text: 'Experience: X years'),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Handle job application
              },
              child: Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class JobDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const JobDetail({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
