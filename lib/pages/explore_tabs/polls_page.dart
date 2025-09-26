import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectx/pages/explore_tabs/polls/poll_detail_page.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchPolls() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sponsor_activities')
        .doc('sub')
        .collection('poll')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPolls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No polls available'));
          }

          final polls = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              final pointsAwarded =
                  int.tryParse(poll['rewardedItem']?.toString() ?? '0') ?? 0;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('poll_attempts')
                    .doc(poll['activityId'])
                    .get(),
                builder: (context, attemptSnapshot) {
                  bool attempted = attemptSnapshot.hasData && attemptSnapshot.data!.exists;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.orange,
                        child: Text(
                          (poll['sponsorName'] ?? 'S')[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        poll['activityTitle'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(poll['rewardDescription'] ?? ''),
                      trailing: attemptSnapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : attempted
                          ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Completed",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: () {
                          final questions =
                          (poll['questions'] as List<dynamic>? ?? [])
                              .map((q) => Map<String, dynamic>.from(q))
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PollDetailPage(
                                userId: currentUser.uid,
                                activityId: poll['activityId'] ?? '',
                                title: poll['activityTitle'] ?? '',
                                description: poll['rewardDescription'] ?? '',
                                sponsorName: poll['sponsorName'] ?? '',
                                sponsorLogo: poll['sponsorLogo'] ?? '',
                                pointsAwarded: pointsAwarded,
                                rewardType: poll['rewardType'] ?? 'Coins',
                                questions: questions,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Participate"),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
