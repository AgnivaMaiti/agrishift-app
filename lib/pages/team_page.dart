import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agro/Providers/language_provider.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.translate('our_team')),
        backgroundColor: const Color(0xFF4D7C0F),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.translate('meet_our_team'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4D7C0F)),
            ),
            SizedBox(height: 20),
            
            Text(
              languageProvider.translate('our_founder'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF4D7C0F)),
            ),
            SizedBox(height: 10),
            _buildFounderSection(),
            
            SizedBox(height: 30),
            
            Text(
              languageProvider.translate('our_mentors'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF4D7C0F)),
            ),
            SizedBox(height: 10),
            _buildTeamSection(mentors),
            
            SizedBox(height: 30),
            
            Text(
              languageProvider.translate('team_members'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF4D7C0F)),
            ),
            SizedBox(height: 10),
            _buildTeamSection(teamMembers),
          ],
        ),
      ),
    );
  }

  Widget _buildFounderSection() {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(projectDirector.imageUrl),
                onBackgroundImageError: (exception, stackTrace) {},
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 16),
              Text(
                projectDirector.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF4D7C0F)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                languageProvider.translate(projectDirector.roleKey) ?? projectDirector.role,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                languageProvider.translate(projectDirector.infoKey) ?? projectDirector.info,
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              if (projectDirector.linkedinUrl.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.link, color: Colors.blue),
                  onPressed: () => _launchURL(projectDirector.linkedinUrl),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(List<TeamMember> members) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _buildTeamCard(context, member);
      },
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamMember member) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return GestureDetector(
      onTap: () => _showMemberDialog(context, member),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(member.imageUrl),
                onBackgroundImageError: (exception, stackTrace) {},
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 12),
              Text(
                member.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4D7C0F),
                ),
              ),
              SizedBox(height: 4),
              Text(
                languageProvider.translate(member.roleKey) ?? member.role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              if (member.linkedinUrl.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.link, color: Colors.blue, size: 22),
                  onPressed: () => _launchURL(member.linkedinUrl),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDialog(BuildContext context, TeamMember member) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(member.imageUrl),
                onBackgroundImageError: (exception, stackTrace) {},
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 16),
              Text(
                languageProvider.translate(member.roleKey) ?? member.role, 
                style: TextStyle(fontStyle: FontStyle.italic)
              ),
              SizedBox(height: 16),
              Text(languageProvider.translate(member.infoKey) ?? member.info),
            ],
          ),
        ),
        actions: [
          if (member.linkedinUrl.isNotEmpty)
            TextButton.icon(
              icon: Icon(Icons.link),
              label: Text(languageProvider.translate('linkedin')),
              onPressed: () => _launchURL(member.linkedinUrl),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.translate('close')),
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
  final String role;
  final String roleKey;
  final String infoKey;

  TeamMember({
    required this.name,
    required this.imageUrl,
    this.linkedinUrl = '',
    this.info = '',
    required this.role,
    this.roleKey = '',
    this.infoKey = '',
  });
}

final TeamMember projectDirector = TeamMember(
  name: "Shubhra Tripathi",
  role: "Founder and Director",
  roleKey: "founder_role",
  imageUrl: "https://i.postimg.cc/65pKbJGz/shubhra-pic.jpg",
  linkedinUrl: "https://www.linkedin.com/in/shubhratripathi",
  info: "Founder and Director of Agrovigya, leading the vision to transform India's agricultural landscape.",
  infoKey: "founder_info",
);

List<TeamMember> teamMembers = [
  TeamMember(
    name: "Siya Nimkar",
    imageUrl: "https://i.postimg.cc/PJ2jfK0m/siya-pic.jpg",
    linkedinUrl: "https://www.linkedin.com/in/siyanamkar",
    info: "Core team member working on development and design.",
    role: "Team Member",
    roleKey: "team_member_role",
    infoKey: "siya_info",
  ),
  TeamMember(
    name: "Shruti Kolhe",
    imageUrl: "https://i.postimg.cc/KjPjcWMq/shrut-pic2-removebg-preview.png",
    linkedinUrl: "https://www.linkedin.com/in/shrutikolhe",
    info: "Core team member focused on product development.",
    role: "Team Member",
    roleKey: "team_member_role",
    infoKey: "shruti_info",
  ),
  TeamMember(
    name: "Suvansh Choudhary",
    imageUrl: "https://i.ibb.co/PzCw2K7/1000158921-01.jpg",
    linkedinUrl: "https://www.linkedin.com/in/suvanshchoudhary",
    info: "Core team member working on technical implementation.",
    role: "Team Member",
    roleKey: "team_member_role",
    infoKey: "suvansh_info",
  ),
  TeamMember(
    name: "Agniva Maiti",
    imageUrl: "https://i.postimg.cc/hgzHNdVc/agniva-pic.jpg",
    linkedinUrl: "https://www.linkedin.com/in/agnivamaiti",
    info: "Core team member leading development efforts.",
    role: "Team Member",
    roleKey: "team_member_role",
    infoKey: "agniva_info",
  ),
  TeamMember(
    name: "Shivam",
    imageUrl: "https://i.postimg.cc/fLkx8mPW/shivam-pic.jpg",
    linkedinUrl: "https://www.linkedin.com/in/shivam",
    info: "Core team member contributing to product development.",
    role: "Team Member",
    roleKey: "team_member_role",
    infoKey: "shivam_info",
  ),
  TeamMember(
    name: "Isha Deolakar",
    imageUrl: "https://i.postimg.cc/NfMkPDmL/ISHa.jpg",
    linkedinUrl: "https://www.linkedin.com/in/ishadeolakar",
    info: "Core team member working on user experience and design.",
    role: "Team Member",
    roleKey: "team_member_role",
    infoKey: "isha_info",
  ),
];

List<TeamMember> mentors = [
  TeamMember(
    name: "Ashok Palande",
    imageUrl: "https://i.ibb.co/PvGB5gp/Ashok-palande-pic.jpg",
    linkedinUrl: "https://www.linkedin.com/in/ashokpalande",
    info: "Mentor providing guidance on agricultural technologies.",
    role: "Mentor",
    roleKey: "mentor_role",
    infoKey: "ashok_info",
  ),
  TeamMember(
    name: "Sunita Adhav",
    imageUrl: "https://i.ibb.co/9kCD72C/sunita-adhav-pic.jpg",
    linkedinUrl: "https://www.linkedin.com/in/sunitaadhav",
    info: "Mentor specializing in rural development strategies.",
    role: "Mentor",
    roleKey: "mentor_role",
    infoKey: "sunita_info",
  ),
  TeamMember(
    name: "Anuja Sharma",
    imageUrl: "https://i.postimg.cc/MHWw8g36/anuja-pic.jpg",
    linkedinUrl: "https://www.linkedin.com/in/anujasharma",
    info: "Mentor with expertise in agricultural economics.",
    role: "Mentor",
    roleKey: "mentor_role",
    infoKey: "anuja_info",
  ),
  TeamMember(
    name: "Aishwarya Yadav",
    imageUrl: "https://i.postimg.cc/Jn38vRqY/aishwarya-pic.jpg0",
    linkedinUrl: "https://www.linkedin.com/in/aishwaryayadav",
    info: "Mentor focusing on sustainable agricultural practices.",
    role: "Mentor",
    roleKey: "mentor_role",
    infoKey: "aishwarya_info",
  ),
];
