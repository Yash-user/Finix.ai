import 'package:flutter/material.dart';
import 'chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechFinix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LandingPage(toggleTheme: _toggleTheme),
    );
  }
}

class LandingPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  
  const LandingPage({
    super.key,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: toggleTheme,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: screenHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade700,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'TechFinix',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Revolutionizing Financial Technology',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade900,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                toggleTheme: toggleTheme,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: const Text(
                          'Chat with AI',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Features Section
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text(
                    'Why Choose TechFinix?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.security,
                        title: 'Secure',
                        description: 'Bank-grade security protocols to protect your data',
                      ),
                      _buildFeatureCard(
                        icon: Icons.speed,
                        title: 'Fast',
                        description: 'Lightning-fast transactions and real-time processing',
                      ),
                      _buildFeatureCard(
                        icon: Icons.support_agent,
                        title: '24/7 Support',
                        description: 'Round-the-clock customer support for all your needs',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // About Section
            Container(
              padding: const EdgeInsets.all(40.0),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'TechFinix is a leading financial technology company dedicated to transforming the way people interact with money. Our innovative solutions empower businesses and individuals to manage their finances more efficiently and securely.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Contact Section
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.blue.shade900),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
