import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:agri/pages/team_page.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D7C0F),
        elevation: 0,
        title: Text(
          languageProvider.translate('about_us'),
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4D7C0F),
                image: DecorationImage(
                  image: AssetImage('assets/images/farming_banner.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Agrovigya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About section
                  SectionTitle(title: 'About Agrovigya'),
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

                  // Vision section
                  SectionTitle(title: 'Our Vision'),
                  SizedBox(height: 16),
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
                            builder: (context) => TeamPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.groups),
                      label: Text(
                        languageProvider.translate('meet_our_team'),
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D7C0F),
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

                  // Contact info
                  SectionTitle(title: languageProvider.translate('contact_us')),
                  SizedBox(height: 16),
                  ContactItem(
                    icon: Icons.email,
                    text: 'support@agriapp.com',
                  ),
                  SizedBox(height: 8),
                  ContactItem(
                    icon: Icons.phone,
                    text: '+91 98765 43210',
                  ),
                  SizedBox(height: 8),
                  ContactItem(
                    icon: Icons.location_on,
                    text: languageProvider.translate('address'),
                  ),
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

  const SectionTitle({required this.title});

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
            color: const Color(0xFF4D7C0F),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 50,
          height: 3,
          color: const Color(0xFF4D7C0F),
        ),
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF4D7C0F),
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
