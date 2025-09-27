import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projectx/pages/explore_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _rewardController = PageController(viewportFraction: 0.9);
  int _currentRewardPage = 0;
  Timer? _timer;

  final PageController _voucherController = PageController(viewportFraction: 0.6);
  int _currentVoucherPage = 0;
  Timer? _voucherTimer;

  // Dummy categories
  final categories = [
    {"name": "Quizzes", "image": "https://via.placeholder.com/60"},
    {"name": "Watch Ads", "image": "https://via.placeholder.com/60"},
    {"name": "Surveys", "image": "https://via.placeholder.com/60"},
    {"name": "Offers", "image": "https://via.placeholder.com/60"},
  ];

  // Dummy vouchers
  final vouchers = [
    {"title": "Voucher 1", "image": "https://via.placeholder.com/120x200"},
    {"title": "Voucher 2", "image": "https://via.placeholder.com/120x200"},
    {"title": "Voucher 3", "image": "https://via.placeholder.com/120x200"},
  ];

  // Dummy tasks
  final tasks = [
    {"title": "Task 1", "points": "+250"},
    {"title": "Task 2", "points": "+200"},
    {"title": "Task 3", "points": "+300"},
  ];

  // Dummy winners
  final winners = [
    {"name": "Alex", "image": "https://via.placeholder.com/50"},
    {"name": "John", "image": "https://via.placeholder.com/50"},
    {"name": "Lara", "image": "https://via.placeholder.com/50"},
  ];

  final List<Map<String, dynamic>> rewardCards = [
    {
      "title": "Start Earning Now",
      "buttonText": "Get Started",
      "bgColor": Colors.orangeAccent,
    },
    {
      "title": "Special Offer",
      "buttonText": "Check Now",
      "bgColor": Colors.blueAccent,
    },
    {
      "title": "Limited Time Deal",
      "buttonText": "Grab Now",
      "bgColor": Colors.greenAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll rewards
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentRewardPage < rewardCards.length - 1) {
        _currentRewardPage++;
      } else {
        _currentRewardPage = 0;
      }
      _rewardController.animateToPage(
        _currentRewardPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    // Auto-scroll vouchers
    _voucherTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentVoucherPage < vouchers.length - 1) {
        _currentVoucherPage++;
      } else {
        _currentVoucherPage = 0;
      }
      _voucherController.animateToPage(
        _currentVoucherPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _voucherTimer?.cancel();
    _rewardController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage:
                      NetworkImage("https://via.placeholder.com/150"),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "BestThings",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Free",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: const [
                          Icon(Icons.monetization_on,
                              color: Colors.orange, size: 18),
                          SizedBox(width: 5),
                          Text(
                            "250",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector( // <-- Wrap with GestureDetector
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExploreScreen(), // Navigate to ExplorePage
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(cat["image"]!),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            cat["name"]!,
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Start Earning Rewards - Auto-scroll
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _rewardController,
                itemCount: rewardCards.length,
                itemBuilder: (context, index) {
                  final card = rewardCards[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: card["bgColor"],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card["title"],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: card["bgColor"],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: Text(
                              card["buttonText"],
                              style: TextStyle(
                                  color: card["bgColor"],
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Earn Vouchers Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Earn Vouchers",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("View All",
                        style: TextStyle(
                            fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220, // Enough height for voucher card + button
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Voucher Card
                            Container(
                              width: 120,
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5)
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  voucher["image"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // "Get Now" Button
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  "Get Now",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Ongoing Tasks Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + View All
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Ongoing Tasks",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "View All",
                      style: TextStyle(
                          fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // List of Tasks
                Column(
                  children: tasks.map((task) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(color: Colors.orange, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            // Circular Task Icon
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.orange.withOpacity(0.2),
                              child: const Icon(Icons.task, color: Colors.orange),
                            ),
                            const SizedBox(width: 16),
                            // Task Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task["title"]!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Daily Challenge", // or "Weekly Challenge"
                                    style:
                                    TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            // Reward Coins
                            Row(
                              children: [
                                const Icon(Icons.monetization_on,
                                    color: Colors.orange, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  task["points"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // 3-dot menu
                            const Icon(Icons.more_vert),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),


            const SizedBox(height: 20),

            // Explore Section
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(16)),
              child: const Center(
                child: Text(
                  "Explore More Features",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Top Winners Today
            const Text("Top Winners Today",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: winners.length,
                itemBuilder: (context, index) {
                  final winner = winners[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(winner["image"]!),
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
