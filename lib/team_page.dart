import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet Our Team'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade900,
                    Colors.grey.shade700,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Our Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Meet the talented individuals behind Finix',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildTeamCard(
                    'assets/images/NikunjPicture.jpeg',
                    'Nikunj Sharma',
                    'https://www.linkedin.com/in/nikunj-sharma-183862289',
                    'https://github.com/Nikunj00170',
                  ),
                  _buildTeamCard(
                    'assets/images/samirPicture.jpeg',
                    'Samir Gupta',
                    'https://www.linkedin.com/in/samir-gupta07062004/',
                    'https://github.com/samir0607',
                  ),
                  _buildTeamCard(
                    'assets/images/yashBindal.jpeg',
                    'Yash Bindal',
                    'https://www.linkedin.com/in/yashbindal23/',
                    'https://github.com/Yash-user',
                  ),
                  _buildTeamCard(
                    'assets/images/adityaNambidi.jpeg',
                    'Aditya Nambidi',
                    'https://www.linkedin.com/in/aditya-nambidi/',
                    'https://github.com/AdityaNambidi',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(
      String imagePath,
      String name,
      String linkedinUrl,
      String githubUrl,
      ) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                IconButton(
                  icon:
                  Image.asset('assets/images/linkedinlogo.png', height: 30,),


                  onPressed: () => _launchURL(linkedinUrl),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.code, size: 30),
                  color: Colors.grey.shade800,
                  onPressed: () => _launchURL(githubUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
