import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectx/pages/explore_tabs/quiz/quiz_detail_page.dart';

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("User not logged in"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sponsor_activities')
          .doc('sub')
          .collection('quiz')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No quizzes available"));
        }

        final quizzes = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final quizData = quizzes[index].data() as Map<String, dynamic>;
            final quizId = quizData['activityId'] ?? '';

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .collection('quiz_attempts')
                  .doc(quizId)
                  .get(),
              builder: (context, attemptSnapshot) {
                final attempted = attemptSnapshot.hasData && attemptSnapshot.data!.exists;

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
                        ((quizData['activityTitle'] ?? 'A') as String).isNotEmpty
                            ? (quizData['activityTitle'] as String)[0].toUpperCase()
                            : 'A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      quizData['activityTitle'] ?? 'Untitled Quiz',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(quizData['rewardDescription'] ?? ''),
                    trailing: attempted
                        ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Completed",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () {
                        // Pass all quiz data and current user ID to next page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizDetailPage(
                              userId: currentUser.uid,
                              activityId: quizData['activityId'] ?? '',
                              title: quizData['activityTitle'] ?? '',
                              description: quizData['rewardDescription'] ?? '',
                              sponsorName: quizData['sponsorName'] ?? '',
                              sponsorLogo: '', // no logo
                              durationSeconds: quizData['durationSeconds'] ?? 0,
                              pointsAwarded: quizData['rewardedItem'] ?? '',
                              rewardType: quizData['rewardType'] ?? '',
                              questions: (quizData['questions'] as List<dynamic>)
                                  .cast<Map<String, dynamic>>(),
                              rewardedItem: quizData['rewardedItem'] ?? '',
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
                      child: const Text("Start"),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
