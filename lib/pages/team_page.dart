import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Team"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Meet Our Team",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildTeamSection("Team Members", teamMembers),
            SizedBox(height: 20),
            Text(
              "Our Faculty Mentors",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildTeamSection("Faculty Mentors", facultyMentors),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(String title, List<TeamMember> members) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _buildTeamCard(context, member);
      },
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamMember member) {
    return GestureDetector(
      onTap: () => _showMemberDialog(context, member),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(member.imageUrl),
            ),
            SizedBox(height: 8),
            Text(
              member.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            IconButton(
              icon: Icon(Icons.linked_camera, color: Colors.blue),
              onPressed: () => _launchURL(member.linkedinUrl),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberDialog(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member.name),
        content: Text(member.info),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class TeamMember {
  final String name;
  final String imageUrl;
  final String linkedinUrl;
  final String info;

  TeamMember({
    required this.name,
    required this.imageUrl,
    required this.linkedinUrl,
    required this.info,
  });
}

List<TeamMember> teamMembers = [
  TeamMember(
    name: "John Doe",
    imageUrl: "assets/images/team1.jpg",
    linkedinUrl: "https://www.linkedin.com/in/johndoe",
    info: "John is a software engineer with expertise in Flutter.",
  ),
  TeamMember(
    name: "Jane Smith",
    imageUrl: "assets/images/team2.jpg",
    linkedinUrl: "https://www.linkedin.com/in/janesmith",
    info: "Jane specializes in UI/UX design and mobile development.",
  ),
];

List<TeamMember> facultyMentors = [
  TeamMember(
    name: "Prof. Alice Johnson",
    imageUrl: "assets/images/faculty1.jpg",
    linkedinUrl: "https://www.linkedin.com/in/alicejohnson",
    info: "Prof. Alice is a mentor guiding research in AI and ML.",
  ),
  TeamMember(
    name: "Dr. Bob Williams",
    imageUrl: "assets/images/faculty2.jpg",
    linkedinUrl: "https://www.linkedin.com/in/bobwilliams",
    info: "Dr. Bob is a leading expert in software engineering.",
  ),
];
