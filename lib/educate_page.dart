import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/app_drawer.dart';

class EducatePage extends StatelessWidget {
  const EducatePage({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
  String extractYouTubeVideoId(String url) {
    final RegExp regex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=|embed\/|v\/|shorts\/|)([A-Za-z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    final match = regex.firstMatch(url);
    return (match != null && match.groupCount >= 1) ? match.group(1)! : '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Learn Online'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
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
                'https://youtu.be/EtqVmE2U4Xo?si=mWlg65knWJOZ6mjX',
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
                'https://youtu.be/Mi2DWlR-rP0?si=-HCXrP111EZ9Le1C',
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
                'https://youtu.be/7PM4rNDr4oI?si=yoG3zSM6JSRdpmDO',
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
    String videoId = extractYouTubeVideoId(videoUrl);

    String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

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
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.error_outline, size: 48),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
                        onPressed: () => _launchURL(videoUrl),
                      ),
                    ),
                  ),
                ],
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