import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class DevScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [Icon(Icons.notifications), SizedBox(width: 10)],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Charts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ChartCard(
              title: "Distance",
              chart: LineChartSample(),
            ),
            ChartCard(
              title: "Transportation",
              chart: PieChartSample(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.blue), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;

  ChartCard({required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text("Last 8 days"),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(8.0),
            child: chart,
          ),
        ],
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 15),
              FlSpot(1, 25),
              FlSpot(2, 5),
              FlSpot(3, 15),
              FlSpot(4, 10),
              FlSpot(5, 15),
            ],
            isCurved: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class PieChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(color: Colors.green, value: 10, title: "10%"),
          PieChartSectionData(color: Colors.blue, value: 45, title: "45%"),
          PieChartSectionData(color: Colors.red, value: 45, title: "45%"),
        ],
      ),
    );
  }
}
