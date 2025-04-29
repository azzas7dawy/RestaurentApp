import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  static const String id = 'statistics';

  Future<Map<String, int>> fetchOrderStatusCounts() async {
    final snapshot = await FirebaseFirestore.instance.collection('orders').get();
    int pending = 0, completed = 0, cancelled = 0;

    for (var doc in snapshot.docs) {
      final status = doc['status'];
      if (status == 'pending') pending++;
      if (status == 'accepted') completed++;
      if (status == 'cancelled') cancelled++;
    }

    return {'Pending': pending, 'Accepted': completed, 'Cancelled': cancelled};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Statistics "),
        backgroundColor: const Color(0xFF2A2E32),
      ),
      backgroundColor: const Color(0xFF1A1D21),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, int>>(
          future: fetchOrderStatusCounts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Status", style: TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.orange,
                          value: data['Pending']!.toDouble(),
                          title: 'Pending',
                          radius: 50,
                          titleStyle: const TextStyle(color: Colors.black),
                        ),
                        PieChartSectionData(
                          color: Colors.green,
                          value: data['Accepted']!.toDouble(),
                          title: 'Accepted',
                          radius: 50,
                          titleStyle: const TextStyle(color: Colors.black),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: data['Cancelled']!.toDouble(),
                          title: 'Cancelled',
                          radius: 50,
                          titleStyle: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text("Weekly Orders", style: TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(height: 20),
                // You can replace this with real Firestore logic for weekly data
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        for (int i = 0; i < 7; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(toY: (i + 1) * 3, color: Colors.blue, width: 16),
                            ],
                          )
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) => Text(['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][value.toInt()],
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
