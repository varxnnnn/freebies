import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectx/pages/explore_tabs/survey/survey_detail_page.dart';

class SurveysPage extends StatelessWidget {
  const SurveysPage({super.key});

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
          .collection('survey')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No surveys available"));
        }

        final surveys = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: surveys.length,
          itemBuilder: (context, index) {
            final surveyData = surveys[index].data() as Map<String, dynamic>;
            final activityId = surveyData['activityId'] ?? '';

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .collection('survey_attempts')
                  .doc(activityId)
                  .get(),
              builder: (context, attemptSnapshot) {
                bool completed = false;
                if (attemptSnapshot.hasData && attemptSnapshot.data!.exists) {
                  completed = true;
                }

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
                        ((surveyData['sponsorName'] ?? 'S') as String).isNotEmpty
                            ? (surveyData['sponsorName'] as String)[0].toUpperCase()
                            : 'S',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      surveyData['activityTitle'] ?? 'Untitled Survey',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(surveyData['rewardDescription'] ?? ''),
                    trailing: completed
                        ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Completed",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () {
                        final questions =
                            (surveyData['questions'] as List<dynamic>?)
                                ?.cast<Map<String, dynamic>>() ??
                                [];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyDetailPage(
                              userId: currentUser.uid,
                              activityId: surveyData['activityId'] ?? '',
                              title: surveyData['activityTitle'] ?? '',
                              description:
                              surveyData['rewardDescription'] ?? '',
                              sponsorName: surveyData['sponsorName'] ?? '',
                              sponsorLogo: surveyData['sponsorLogo'] ?? '',
                              rewardType: surveyData['rewardType'] ?? '',
                              rewardedItem: surveyData['rewardedItem'] ?? '',
                              questions: questions, pointsAwarded: surveyData['rewardedItem'] ?? '',
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
    );
  }
}
