import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:agri/pages/team_page.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image(
                  image: AssetImage('assets/images/about.jpg'),
                  fit: BoxFit
                      .cover, // Ensures the background image covers the entire area
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('assets/images/trim_logo.png'),
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Agrovigya',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Ensure it's visible on the background
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      title:
                          'Transforming Agriculture, Empowering Rural Workforce, and Bridging Employment Gaps for a Sustainable Future'),
                  SizedBox(height: 16),
                  Text(
                    'Agrovigya is a pioneering digital platform committed to transforming India\'s agricultural landscape by addressing disguised unemployment and fostering sustainable livelihoods. Our mission is to empower farmers, job seekers, and rural workers by integrating technology-driven solutions that bridge the gap between agriculture, employment, and skill development.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Through data-driven crop recommendations, labor estimation tools, and job-matching services, we optimize agricultural productivity while connecting job seekers with relevant employment opportunities. Agrovigya also facilitates upskilling programs to enhance employability and provides seamless access to government schemes, subsidies, and financial aid.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'By leveraging AI-driven insights and a user-friendly interface, we ensure accessibility and efficiency in rural workforce development. Our platform is more than just an app—it\'s a movement toward economic self-sufficiency, enabling farmers to increase their earnings, reducing unemployment, and creating a sustainable, technology-driven agricultural ecosystem.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 32),

                  SectionTitle(title: 'Our Vision'),
                  SizedBox(height: 16),
                  Image(image: AssetImage('assets/images/about_1.jpg')),
                  Text(
                    'At Agrovigya, we envision a future where agriculture thrives through modernization, rural employment is optimized, and individuals have access to the skills and opportunities necessary for economic growth. Our goal is to create a sustainable ecosystem where farmers maximize productivity through data-driven insights, job seekers find meaningful employment beyond agriculture, and skill development bridges the gap between industry needs and workforce capabilities.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'By integrating technology, innovation, and government support, we strive to empower rural communities, reduce disguised unemployment, and foster a resilient agricultural economy that is both profitable and future-ready.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 32),

                  // Mission section
                  SectionTitle(title: 'Our Mission'),
                  SizedBox(height: 16),
                  Image(image: AssetImage('assets/images/about_2.jpg')),
                  Text(
                    'Our mission is to empower farmers with smarter agricultural practices, connect job seekers with meaningful employment opportunities, and bridge skill gaps through targeted upskilling programs. By integrating government schemes, financial support, and industry-driven training, we aim to enhance productivity, increase incomes, and create a self-reliant rural economy.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Through innovation and collaboration, we strive to build a future where agriculture is sustainable, employment is accessible, and every individual has the tools to achieve economic growth.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Meet our team button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfessionalDirectory(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.groups_2_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: Text(
                        languageProvider.translate('Meet Our Team'),
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF147b2c),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                  //   TeamMember()

                  //   SectionTitle(title: languageProvider.translate('contact_us')),
                  //   SizedBox(height: 16),
                  //   ContactItem(
                  //     icon: Icons.email,
                  //     text: 'support@agriapp.com',
                  //   ),
                  //   SizedBox(height: 8),
                  //   ContactItem(
                  //     icon: Icons.phone,
                  //     text: '+91 98765 43210',
                  //   ),
                  //   SizedBox(height: 8),
                  //   ContactItem(
                  //     icon: Icons.location_on,
                  //     text: languageProvider.translate('address'),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF147b2c),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 50,
          height: 3,
          color: const Color(0xFF147b2c),
        ),
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF147b2c),
          size: 20,
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class TeamMember extends StatefulWidget {
  const TeamMember({super.key});

  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisExtent: 10),
        itemBuilder: (context, index) {
          return Container();
        });
  }
}
