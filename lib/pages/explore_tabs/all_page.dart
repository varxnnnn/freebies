import 'package:flutter/material.dart';

class AllPage extends StatelessWidget {
  const AllPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _quickEarnList = const [
    {
      'title': 'Shopping Habits Research',
      'desc': 'Help improve shopping experience',
      'type': 'Survey',
      'points': '100 pts',
      'time': '3 min',
    },
    {
      'title': 'New App Feedback',
      'desc': 'Give your opinion on a new app',
      'type': 'Poll',
      'points': '50 pts',
      'time': '2 min',
    },
    {
      'title': 'Market Survey',
      'desc': 'Share your preferences',
      'type': 'Survey',
      'points': '80 pts',
      'time': '4 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Offer Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Earn Instant",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Flipkart Voucher",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "of Worth \$300",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple[500],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Now Ranked #1",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: const Center(
                      child: Text("logo",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Featured Offers & Tech Challenge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured\nOffers",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * 0.02,
                        mainAxisSpacing: screenWidth * 0.02,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final labels = ["Gains", "Skin", "Voucher", "Electronics"];
                        return Container(
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[300]!),
                          ),
                          child: Center(
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Container(
                width: screenWidth * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tech\nKnowledge\nChallenge",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Test your tech knowledge",
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Ongoing",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "21 Questions",
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        "Start Now",
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),

          // Quick Earn Cards
          const Text(
            "Quick Earn",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(height: screenHeight * 0.02),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickEarnList.length,
            itemBuilder: (context, index) {
              final item = _quickEarnList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1), blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item['desc']!,
                          style: TextStyle(
                              fontSize: screenWidth * 0.03, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[500],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item['type']!,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${item['points']} | ${item['time']}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }
}
