import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/more/pages/feedback_page.dart';
import 'package:jaga_app/app/pages/more/pages/rateus_page.dart';
import 'package:jaga_app/app/pages/more/widgets/menu_card.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth - 48) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'MORE',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuCard(
                    icon: Icons.feedback_outlined,
                    label: 'Feedback',
                    iconColor: Colors.white,
                    width: cardWidth,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FeedbackPage()),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.star,
                    label: 'Rate Us',
                    iconColor: Colors.amber,
                    width: cardWidth,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RateUsPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}