import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducatePage extends StatelessWidget {
  const EducatePage({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Education'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Stocks',
                'Learn about stock market basics, how to analyze stocks, and investment strategies.',
                'https://youtu.be/GcZW24SkbHM?si=MYqlLpaGbsYGeR-W',
                [
                  'Understanding stock market fundamentals',
                  'How to analyze company financials',
                  'Investment strategies for beginners',
                  'Risk management in stock trading',
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Commodities',
                'Explore the world of commodity trading, from precious metals to agricultural products.',
                'https://www.youtube.com/embed/0TQ0RBNcgic',
                [
                  'Types of commodities (metals, energy, agriculture)',
                  'Factors affecting commodity prices',
                  'How to invest in commodities',
                  'Commodity trading strategies',
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Futures',
                'Understanding futures contracts and their role in financial markets.',
                'https://www.youtube.com/embed/0TQ0RBNcgic',
                [
                  'What are futures contracts?',
                  'How futures trading works',
                  'Hedging with futures',
                  'Speculation vs hedging',
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Options',
                'Learn about options trading, from basic concepts to advanced strategies.',
                'https://www.youtube.com/embed/0TQ0RBNcgic',
                [
                  'Call and put options explained',
                  'Options pricing and Greeks',
                  'Options trading strategies',
                  'Risk management in options trading',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, String videoUrl, List<String> keyPoints) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.play_circle_outline, size: 64),
                    onPressed: () => _launchURL(videoUrl),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Key Points:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...keyPoints.map((point) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL(videoUrl),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900,
                foregroundColor: Colors.white,
              ),
              child: const Text('Watch Video'),
            ),
          ],
        ),
      ),
    );
  }
}