import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BestThings Free',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: LeaderboardPage(),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              "BestThings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Free",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.monetization_on, size: 20, color: Colors.orange),
                SizedBox(width: 4),
                Text("₹ 250", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top 3 Leaders - Improved Layout (Pyramid Style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTopRankCard(
                      rank: "#2",
                      name: "Jack Nicklson",
                      points: "25,006",
                      avatar: "https://i.imgur.com/9KZuFfT.png",
                      color: Colors.orangeAccent,
                      heightFactor: 1.75,
                    ),
                    const SizedBox(width: 12),
                    _buildTopRankCard(
                      rank: "#1",
                      name: "Joe Addamson",
                      points: "29,096",
                      avatar: "https://i.imgur.com/LpQ7vLd.png",
                      color: Colors.greenAccent,
                      heightFactor: 2.0,
                    ),
                    const SizedBox(width: 12),
                    _buildTopRankCard(
                      rank: "#3",
                      name: "Alley Sholay",
                      points: "20,753",
                      avatar: "https://i.imgur.com/YeWcVYq.png",
                      color: Colors.purpleAccent,
                      heightFactor: 1.5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Rank List
              _buildRankItem(
                rank: "#4",
                name: "Rolex Roar",
                points: "19,053",
                avatar: "https://i.imgur.com/YeWcVYq.png",
                trend: "up",
                bgColor: Colors.white,
                borderColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              ),
              SizedBox(height: 10),
              _buildRankItem(
                rank: "#5",
                name: "S. K. Amar",
                points: "27,342",
                avatar: "https://i.imgur.com/YeWcVYq.png",
                trend: "down",
                bgColor: Colors.white,
                borderColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              ),
              SizedBox(height: 10),
              _buildRankItem(
                rank: "#6",
                name: "Amber hui",
                points: "15,090",
                avatar: "https://i.imgur.com/YeWcVYq.png",
                trend: "up",
                bgColor: Colors.white,
                borderColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              ),
              SizedBox(height: 10),
              _buildRankItem(
                rank: "#98",
                name: "Alex Rivera",
                points: "19,053",
                avatar: "https://i.imgur.com/YeWcVYq.png",
                trend: "up",
                bgColor: Colors.orangeAccent,
                borderColor: const Color.fromARGB(255, 255, 145, 2),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildTopRankCard({
    required String rank,
    required String name,
    required String points,
    required String avatar,
    required Color color,
    double heightFactor = 1.0,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(avatar.trim()), // Trim whitespace
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 90,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "₹ $points",
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 80 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              rank,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem({
    required String rank,
    required String name,
    required String points,
    required String avatar,
    required String trend,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(avatar.trim()), // Trim whitespace
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "₹ $points",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(
            trend == "up" ? Icons.arrow_upward : Icons.arrow_downward,
            color: trend == "up" ? Colors.green : Colors.red,
            size: 16,
          ),
        ],
      ),
    );
  }
}