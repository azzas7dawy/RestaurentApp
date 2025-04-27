import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/screens/adminDashbord/admin/MenuScreen%20.dart';
import 'package:restrant_app/screens/adminDashbord/admin/admin_orders_screen.dart';
import 'package:restrant_app/screens/adminDashbord/admin/orders_screen.dart';
import 'package:restrant_app/screens/adminDashbord/admin/statistics_screen.dart';
import 'package:restrant_app/screens/adminDashbord/chat.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});
  static const String id = 'dashboard_home_screen';

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  int totalReservations = 0;
  int todaysOrders = 0;
  Map<String, int> weeklyOrders = {
    'Sat': 0,
    'Sun': 0,
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0
  };

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    final today = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(today);

    final reservationsSnapshot =
        await FirebaseFirestore.instance.collection('reservations').get();
    totalReservations = reservationsSnapshot.docs.length;

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('date', isEqualTo: todayStr)
        .get();
    todaysOrders = ordersSnapshot.docs.length;

    final weekStart = today.subtract(Duration(days: today.weekday % 7));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final weeklySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(weekEnd))
        .get();

    for (var doc in weeklySnapshot.docs) {
      final timestamp = (doc['timestamp'] as Timestamp).toDate();
      final day = DateFormat('E').format(timestamp); // e.g. 'Mon'
      if (weeklyOrders.containsKey(day)) {
        weeklyOrders[day] = weeklyOrders[day]! + 1;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF212529),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Text("Admin Dashboard",
                style: TextStyle(
                    color:ColorsUtility.progressIndictorColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const Divider(color: Colors.grey),
            ListTile(
              title:
                  const Text("Orders", style: TextStyle(color: ColorsUtility.progressIndictorColor)),
              onTap: () {
                Navigator.pushNamed(context, OrdersScreenn.id);
              },
            ),
            ListTile(
              title: const Text("Menu", style: TextStyle(color:ColorsUtility.progressIndictorColor)),
              onTap: () => Navigator.pushNamed(context, AdminMenuScreen.id),
            ),
            ListTile(
              title: const Text("Admin Orders",
                  style: TextStyle(color:ColorsUtility.progressIndictorColor)),
              onTap: () => Navigator.pushNamed(context, AdminOrdersScreen.id),
            ),
            ListTile(
              title: const Text("Statisics",
                  style: TextStyle(color: ColorsUtility.progressIndictorColor)),
              onTap: () => Navigator.pushNamed(context, StatisticsScreen.id),
            ),
            ListTile(
              title: const Text("Chat", style: TextStyle(color: ColorsUtility.progressIndictorColor)),
                 onTap: () => Navigator.push(context, MaterialPageRoute( builder: (context) => ChatScreen(   otherUserEmail:
                                FirebaseAuth.instance.currentUser?.email ?? 'admin@gmail.com',
                            ))),
            ),
            ListTile(
              title: const Text("Dashboard",
                  style: TextStyle(color:ColorsUtility.progressIndictorColor)),
              onTap: () => Navigator.pushReplacementNamed(
                  context, DashboardHomeScreen.id),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Dashboard",
            style: TextStyle(
                color: ColorsUtility.progressIndictorColor,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 33, 75, 81),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard("Total Reservations", "$totalReservations",
                Icons.event_seat, Colors.teal),
            _buildStatCard("Today's Orders", "$todaysOrders ",
                Icons.shopping_cart, Colors.orange),
            const SizedBox(height: 20),
            const Text("Weekly Orders",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final days = [
                          'Sat',
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri'
                        ];
                        return Text(days[value.toInt()],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10));
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                        7,
                        (index) => FlSpot(index.toDouble(),
                            (weeklyOrders.values.toList()[index]).toDouble())),
                    isCurved: true,
                    color: ColorsUtility.progressIndictorColor,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                        show: true, color: ColorsUtility.progressIndictorColor.withOpacity(0.3)),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      color: const Color(0xFF2A2E32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
