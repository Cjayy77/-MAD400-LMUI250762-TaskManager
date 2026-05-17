import 'package:flutter/material.dart';

// Profile screen — shows personal info, bio, and semester goals
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header banner + overlapping avatar ──────────────────
            // Stack lets the avatar sit on top of the banner edge
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Dark banner background
                Container(
                  height: 100,
                  color: const Color(0xFF1A1A1A),
                ),

                // Avatar overlaps the banner bottom edge
                Positioned(
                  bottom: -30,
                  left: 20,
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: const Color(0xFF00897B), // teal
                    // White border so it pops off both the banner and the page
                    child: CircleAvatar(
                      radius: 41,
                      backgroundColor: const Color(0xFF00897B),
                      child: const Text(
                        'CJ', // ← CHANGE: your initials e.g. 'CA'
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Space so content clears the overlapping avatar
            const SizedBox(height: 44),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Name ──────────────────────────────────────────
                  const Text(
                    'Cedric Julien Eboule',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ── Badges ────────────────────────────────────────
                  Row(
                    children: [
                      _badge('Level 400', const Color(0xFF1A1A1A)),
                      const SizedBox(width: 6),
                      _badge('Software Engineering', const Color(0xFF00897B)),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // ── Student ID ────────────────────────────────────
                  Text(
                    'Student ID: LMUI250762', // ← CHANGE: your student ID
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Divider ───────────────────────────────────────
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── About Me ──────────────────────────────────────
                  const Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    
                    'I am a Level 400 Software Engineering student'
                    'i I enjoy building '
                    'apps that solve everyday problems and are pleasant to use. '
                    'Outside of academics, I work on personal projects and am always '
                    'looking to improve my technical skills.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF444444),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Divider ───────────────────────────────────────
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── Goals ─────────────────────────────────────────
                  const Text(
                    'Goals this semester',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _goalItem('Complete all assignments before deadlines'),
                  _goalItem('Graduate'),
                  _goalItem('Maintain a strong GPA this semester'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Coloured pill badge — used for Level 400 and programme
  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Goal row with a teal checkbox-style icon
  Widget _goalItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teal checkbox box
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00897B), width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              size: 12,
              color: Color(0xFF00897B),
            ),
          ),
          const SizedBox(width: 10),
          // Goal text
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}