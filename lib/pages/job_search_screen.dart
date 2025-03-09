import 'package:flutter/material.dart';

class JobSearchScreen extends StatelessWidget {
  const JobSearchScreen({super.key});

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
              'Available Jobs',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
    final double paddingValue = MediaQuery.of(context).size.width * 0.04;
    final double borderRadiusValue = MediaQuery.of(context).size.width * 0.03;

    return Padding(
      padding: EdgeInsets.only(bottom: paddingValue),
      child: Container(
        padding: EdgeInsets.all(paddingValue),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: MediaQuery.of(context).size.width * 0.02,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm Worker Position ${index + 1}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            JobDetail(icon: Icons.location_on_outlined, text: 'Farm Location'),
            JobDetail(icon: Icons.money, text: 'Salary: \$XX,XXX'),
            JobDetail(
                icon: Icons.work_history_outlined, text: 'Experience: X years'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
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
              ),
            )
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
    final double iconSize = MediaQuery.of(context).size.width * 0.06;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: Colors.grey[600]),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Text(
            text,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
          ),
        ],
      ),
    );
  }
}
