import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  // 🔸 FOR TESTING: Hardcode the UID from your screenshot
  final String _testUserId = "5Lo4wvbhvPRi6RdXNa1n9U86xRw1";
  
  
  Future<List<Map<String, dynamic>>> fetchUserRewards() async {
    print("🔍 fetchUserRewards() called");
    print("👤 Current authenticated UID: $_uid");
    print("🧪 Using test UID for query: $_testUserId");

    // Use test UID for now (replace with _uid when ready)
    final String effectiveUid = _testUserId; // 👈 TEMP: forces correct user

    if (effectiveUid.isEmpty) {
      print("⚠️ No user ID available");
      return [];
    }

    try {
      print("📡 Fetching redemptions for user: $effectiveUid");
      final redemptionSnapshot = await _firestore
          .collection('redemptions')
          .where('user_id', isEqualTo: effectiveUid)
          .get();

      print("✅ Got ${redemptionSnapshot.docs.length} redemptions");

      final List<Map<String, dynamic>> rewards = [];
      for (var redemption in redemptionSnapshot.docs) {
        final data = redemption.data();
        final rewardId = data['reward_id']?.toString()?.trim();
        print("📦 Processing redemption: ${redemption.id}, reward_id: $rewardId");

        if (rewardId == null || rewardId.isEmpty) {
          print("❌ Skipping: reward_id is null or empty");
          continue;
        }

        final rewardDoc = await _firestore
            .collection('sponsor_rewards')
            .doc(rewardId)
            .get();

        if (rewardDoc.exists) {
          final rewardData = rewardDoc.data()!;
          print("✅ Found reward: ${rewardData['title'] ?? 'N/A'}");

          rewards.add({
            "title": rewardData['title'] ?? "Reward",
            "image": "https://via.placeholder.com/40/4ECDC4/FFFFFF?text=R",
            "cost_points": rewardData['cost_points'] ?? 0,
            "status": data['status'] ?? "pending",
          });
        } else {
          print("❌ Reward not found for ID: $rewardId");
        }
      }

      print("🎉 Returning ${rewards.length} user rewards");
      return rewards;
    } catch (e, stack) {
      print("💥 Error in fetchUserRewards: $e");
      print("STACK: $stack");
      return [];
    }
  }

  // Keep fetchAllRewards for fallback
  Future<List<Map<String, dynamic>>> fetchAllRewards() async {
    try {
      final snapshot = await _firestore
          .collection('sponsor_rewards')
          .where('status', isEqualTo: 'active')
          .get();

      final List<Map<String, dynamic>> rewards = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        rewards.add({
          "title": data['title'] ?? "Reward",
          "image": "https://via.placeholder.com/40/4ECDC4/FFFFFF?text=R",
          "cost_points": data['cost_points'] ?? 0,
          "status": "available",
        });
      }
      return rewards;
    } catch (e) {
      return [];
    }
  }
}