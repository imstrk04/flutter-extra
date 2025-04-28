import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(EcoHabitTrackerApp());
}

class EcoHabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HabitHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Habit {
  final String name;
  int frequency;

  Habit({required this.name, this.frequency = 0});
}

class HabitHomePage extends StatefulWidget {
  @override
  _HabitHomePageState createState() => _HabitHomePageState();
}

class _HabitHomePageState extends State<HabitHomePage> {
  List<Habit> habits = [];
  final TextEditingController habitController = TextEditingController();

  final List<String> dailyQuotes = [
    "The Earth is what we all have in common.",
    "Small acts, when multiplied, can transform the world.",
    "Be the change you want to see in the world.",
    "Protect our planet, it's the only one we have.",
    "Every act counts towards saving the Earth."
  ];

  String todayQuote = "";

  @override
  void initState() {
    super.initState();
    todayQuote = dailyQuotes[Random().nextInt(dailyQuotes.length)];
  }

  void _addHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Habit'),
          content: TextField(
            controller: habitController,
            decoration: InputDecoration(labelText: 'Habit Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (habitController.text.isNotEmpty) {
                  setState(() {
                    habits.add(Habit(name: habitController.text));
                  });
                  habitController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _incrementHabit(Habit habit) {
    setState(() {
      habit.frequency++;
    });
  }

  List<charts.Series<Habit, String>> _createChartData() {
    return [
      charts.Series<Habit, String>(
        id: 'Habits',
        domainFn: (Habit habit, _) => habit.name,
        measureFn: (Habit habit, _) => habit.frequency,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: habits,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eco Habit Tracker'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green[100],
            padding: EdgeInsets.all(16),
            child: Text(
              '🌿 Quote of the Day:\n"$todayQuote"',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: habits.isEmpty
                ? Center(child: Text('No habits added yet!'))
                : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(habit.name),
                    subtitle: Text('Frequency: ${habit.frequency}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _incrementHabit(habit),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.all(10),
            child: habits.isEmpty
                ? Center(child: Text('No data to plot yet.'))
                : charts.BarChart(
              _createChartData(),
              animate: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: Icon(Icons.add),
      ),
    );
  }
}
