import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calender',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PlanManagerScreen(),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  bool completed;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.completed = false,
  });
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key});

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];
  DateTime _selectedDay = DateTime.now();

  void _addPlan(String name, String description, DateTime date) {
    setState(() {
      plans.add(Plan(name: name, description: description, date: date));
    });
  }

  void _editPlan(int index) {
    TextEditingController nameController = TextEditingController(
      text: plans[index].name,
    );
    TextEditingController descController = TextEditingController(
      text: plans[index].description,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Your Plans'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  plans[index].name = nameController.text;
                  plans[index].description = descController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _toggleComplete(int index) {
    setState(() {
      plans[index].completed = !plans[index].completed;
    });
  }

  void _deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  void _showCreatePlanDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addPlan(
                  nameController.text,
                  descController.text,
                  _selectedDay,
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan Management')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                Color planColor =
                    Colors.primaries[index % Colors.primaries.length].shade200;
                return GestureDetector(
                  onLongPress: () => _editPlan(index),
                  onDoubleTap: () => _deletePlan(index),
                  child: Dismissible(
                    key: Key(plans[index].name),
                    background: Container(color: Colors.green),
                    onDismissed: (direction) => _toggleComplete(index),
                    child: Card(
                      color:
                          plans[index].completed
                              ? Colors.green[200]
                              : planColor,
                      child: ListTile(
                        title: Text(plans[index].name),
                        subtitle: Text(plans[index].description),
                        trailing: Icon(
                          plans[index].completed
                              ? Icons.check_circle
                              : Icons.pending,
                          color:
                              plans[index].completed
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlanDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
