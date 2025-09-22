import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const ProfilePage());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool _loading = true;

  String _selectedLanguage = "English";
  bool _isNotified = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
          _loading = false;
        });
      }
    }
  }

  void _onCopyReferralCode() {
    if (userData != null && userData!['referralCode'] != null) {
      Clipboard.setData(ClipboardData(text: userData!['referralCode']));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Referral code copied!")),
      );
    }
  }

  void _onLanguageChange(String lang) {
    setState(() {
      _selectedLanguage = lang;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Language changed to $lang")),
    );
  }

  void _onToggleNotification(bool value) {
    setState(() {
      _isNotified = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Use default values if Firestore fields are null
    String name = userData?['name'] ?? "User Name";
    String email = userData?['email'] ?? "email@example.com";
    String level = "Starter Level"; // can map based on currentLevel if needed
    int currentLevel = userData?['currentLevel'] ?? 0;
    int activitiesCompleted = userData?['activitiesCompleted'] ?? 0;
    int wallet = userData?['wallet'] ?? 0;
    int totalPoints = userData?['totalPoints'] ?? 0;
    String referralCode = userData?['referralCode'] ?? "XXXX";
    int vouchers = userData?['vouchers'] ?? 0;
    int friendsReferred = userData?['friendsReferred'] ?? 0;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),

            // Header with logo
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Row(
                children: [
                  Text(
                    "BestThings",
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Free",
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // User Info Card
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.1,
                    backgroundImage: NetworkImage(
                      "https://via.placeholder.com/100/FF6B6B/FFFFFF?text=${name.substring(0, 2).toUpperCase()}",
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          level,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  icon: Icons.person_outline,
                  label: "Current Level",
                  value: "$currentLevel",
                ),
                _buildStatCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  icon: Icons.check_box,
                  label: "Activities Completed",
                  value: "$activitiesCompleted",
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  icon: Icons.wallet,
                  label: "Current Wallet",
                  value: "$wallet",
                ),
                _buildStatCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  icon: Icons.star,
                  label: "Total Points",
                  value:
                  "${totalPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}",
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Invite Friends Section
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invite Friends",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Share your referral code and earn bonus points",
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            referralCode,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      ElevatedButton(
                        onPressed: _onCopyReferralCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          "Copy",
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Vouchers & Referrals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVoucherCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  icon: Icons.local_offer,
                  label: "My Vouchers",
                  value: "$vouchers",
                ),
                _buildVoucherCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  icon: Icons.people,
                  label: "Friends Referred",
                  value: "$friendsReferred",
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Settings & Preferences
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings & Preferences",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "Language Selection",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _onLanguageChange("English"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedLanguage == "English"
                                  ? Colors.orange
                                  : Colors.grey[200],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                            child: Text(
                              "English",
                              style: TextStyle(fontSize: screenWidth * 0.03),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          ElevatedButton(
                            onPressed: () => _onLanguageChange("Hindi"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedLanguage == "Hindi"
                                  ? Colors.orange
                                  : Colors.grey[200],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                            child: Text(
                              "Hindi",
                              style: TextStyle(fontSize: screenWidth * 0.03),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "Get notified about new activities",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _isNotified,
                        onChanged: _onToggleNotification,
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required double screenWidth,
    required double screenHeight,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: screenWidth * 0.45,
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: screenWidth * 0.06),
          SizedBox(height: screenHeight * 0.01),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard({
    required double screenWidth,
    required double screenHeight,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: screenWidth * 0.45,
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: screenWidth * 0.06),
          SizedBox(height: screenHeight * 0.01),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
