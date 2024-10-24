import 'package:bond/styles/styles.dart';
import 'package:flutter/material.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Màu nền của AppBar
        elevation: 4.0, // Độ cao của bóng đổ
        title: Center(
          child: Text(
            "Pricing Plan",
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // Thêm thanh phân cách
          child: Container(
            color: Colors.grey.shade300, // Màu thanh phân cách
            height: 4.0,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SubscriptionCard(
              title: 'Basic',
              price: 'Free',
              features: [
                'AI Chat Model: GPT-3.5',
                'AI Action Injection',
                'Select Text for AI Action',
              ],
              limitedQueries: '50 free queries per day',
              advancedFeatures: [
                'AI Reading Assistant',
                'Real-time Web Access',
                'AI Writing Assistant',
                'AI Pro Search',
              ],
              otherBenefits: [
                'Lower response speed during high-traffic',
              ],
            ),
            SubscriptionCard(
              title: 'Starter',
              price: '1-month Free Trial\nThen \$9.99/month',
              features: [
                'AI Chat Models: GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra',
                'AI Action Injection',
                'Select Text for AI Action',
              ],
              limitedQueries: 'Unlimited queries per month',
              advancedFeatures: [
                'AI Reading Assistant',
                'Real-time Web Access',
                'AI Writing Assistant',
                'AI Pro Search',
              ],
              otherBenefits: [
                'No request limits during high-traffic',
                '2X faster response speed',
                'Priority email support',
              ],
            ),
            SubscriptionCard(
              title: 'Pro Annually',
              price: '1-month Free Trial\nThen \$79.99/year',
              features: [
                'AI Chat Models: GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra',
                'AI Action Injection',
                'Select Text for AI Action',
              ],
              limitedQueries: 'Unlimited queries per year',
              advancedFeatures: [
                'AI Reading Assistant',
                'Real-time Web Access',
                'AI Writing Assistant',
                'AI Pro Search',
                'Jira Copilot Assistant',
                'Github Copilot Assistant',
              ],
              otherBenefits: [
                'No request limits during high-traffic',
                '2X faster response speed',
                'Priority email support',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final String limitedQueries;
  final List<String> advancedFeatures;
  final List<String> otherBenefits;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.limitedQueries,
    required this.advancedFeatures,
    required this.otherBenefits,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getTitleColor(title),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text('Basic features:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...features.map((feature) => Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        feature,
                        softWrap: true, // Optional: enables soft wrapping
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 8),
            const Text('Limited queries:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(limitedQueries),
            const SizedBox(height: 16),
            const Text('Advanced features:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...advancedFeatures.map((feature) => Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(feature),
                  ],
                )),
            const SizedBox(height: 16),
            const Text('Other benefits:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...otherBenefits.map((benefit) => Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(benefit),
                  ],
                )),
            const SizedBox(height: 16),
            if (title != 'Basic') ...[
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _getButtonColor(title),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Subscribe now'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTitleColor(String title) {
    switch (title) {
      case 'Basic':
        return Colors.blue;
      case 'Starter':
        return Colors.green;
      case 'Pro Annually':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Color _getButtonColor(String title) {
    switch (title) {
      case 'Basic':
        return Colors.blue;
      case 'Starter':
        return Colors.green;
      case 'Pro Annually':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}
