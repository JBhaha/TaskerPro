import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskerpro/model/task.dart';
import 'package:taskerpro/model/task_list.dart';
import 'package:vibration/vibration.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTaskPageState();
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController txtController = TextEditingController();
  var priority = 1;

  @override
  Widget build(BuildContext context) {
    TaskList tasks = Provider.of<TaskList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Task...',
            ),
            controller: txtController,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Priority"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: prioritySelect(),
            ),
          ],
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (await Vibration.hasAmplitudeControl() != null) {
              Vibration.vibrate(duration: 200, amplitude: 128);
            }
            tasks.addTask(Task(txtController.text, priority, false));
            Navigator.pop(context);
          },
          child: Text("Add")),
    );
  }

  Widget prioritySelect() {
    const List<int> list = <int>[1, 2, 3, 4, 5];
    return DropdownButton<int>(
      value: priority,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.amberAccent,
      ),
      onChanged: (int? value) {
        // This is called when the user selects an item.
        setState(() {
          priority = value!;
        });
      },
      items: list.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
