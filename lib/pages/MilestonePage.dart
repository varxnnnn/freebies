import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MilestonePage(),
  ));
}

class MilestonePage extends StatefulWidget {
  const MilestonePage({super.key});

  @override
  State<MilestonePage> createState() => _MilestonePageState();
}

class _MilestonePageState extends State<MilestonePage> {
  // Dummy milestone tasks
  final List<Map<String, dynamic>> tasks = [
    {"title": "Task 1", "subtitle": "Complete 5 Surveys", "points": 100, "completed": false},
    {"title": "Task 2", "subtitle": "Complete 5 Surveys", "points": 100, "completed": false},
    {"title": "Task 3", "subtitle": "Complete 5 Surveys", "points": 100, "completed": false},
    {"title": "Task 4", "subtitle": "Complete 5 Surveys", "points": 100, "completed": false},
    {"title": "Task 5", "subtitle": "Complete 5 Surveys", "points": 100, "completed": true},
    {"title": "Task 6", "subtitle": "Complete 5 Surveys", "points": 100, "completed": true},
    {"title": "Task 7", "subtitle": "Complete 5 Surveys", "points": 100, "completed": true},
  ];

  @override
  Widget build(BuildContext context) {
    int completedCount = tasks.where((t) => t["completed"] == true).length;
    double progress = completedCount / tasks.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        TextSpan(text: "BestThings"),
                        TextSpan(
                            text: "Free",
                            style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.orange),
                      const SizedBox(width: 4),
                      const Text("₹ 250",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  )
                ],
              ),
            ),
            // Progress Bar Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Column(
                children: [
                  const Text("Progress",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: progress,
                      backgroundColor: Colors.red.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return GestureDetector(
                    onTap: () {
                      // toggle completion when tapped
                      setState(() {
                        task["completed"] = !task["completed"];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox/Star
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.orange, width: 2),
                              color: task["completed"]
                                  ? Colors.orange
                                  : Colors.transparent,
                            ),
                            child: task["completed"]
                                ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                                : const Icon(Icons.star_border,
                                color: Colors.orange, size: 20),
                          ),
                          const SizedBox(width: 12),

                          // Task Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task["title"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                Text(task["subtitle"],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87)),
                                Text("Earn ${task["points"]} points",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}