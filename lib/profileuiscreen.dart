import 'package:flutter/material.dart';

import 'editprofilescreen.dart';

class ProfileScreenUI extends StatefulWidget {
  const ProfileScreenUI({super.key});

  @override
  State<ProfileScreenUI> createState() => _ProfileScreenUIState();
}

class _ProfileScreenUIState extends State<ProfileScreenUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F0),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            // 🔹 Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40), // cân layout
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Content + Scroll
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // 🔹 Account Setting
                  sectionTitle("Account Setting"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: settingItem(Icons.person, "Edit profile"),
                  ),
                  settingItem(Icons.language, "Change language"),
                  settingItem(Icons.lock, "Privacy"),

                  const SizedBox(height: 20),

                  // 🔹 Support (NEW)
                  sectionTitle("Support"),
                  settingItem(Icons.help_outline, "Help"),
                  settingItem(Icons.info_outline, "About RiceCare AI"),

                  const SizedBox(height: 20),

                  // 🔹 Legal (UPDATED)
                  sectionTitle("Legal"),
                  settingItem(
                    Icons.description,
                    "Terms and Conditions",
                    isExternal: true,
                  ),
                  settingItem(
                    Icons.privacy_tip,
                    "Privacy Policy",
                    isExternal: true,
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Logout
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔹 Version
                  Center(
                    child: Text(
                      "Version 1.0.0",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Section title
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green[900],
          fontSize: 14,
        ),
      ),
    );
  }

  // 🔹 Item
  Widget settingItem(IconData icon, String text, {bool isExternal = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1EA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green[900]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.green[900])),
          ),
          Icon(
            isExternal ? Icons.open_in_new : Icons.chevron_right,
            size: 18,
            color: Colors.green[900],
          ),
        ],
      ),
    );
  }
}
