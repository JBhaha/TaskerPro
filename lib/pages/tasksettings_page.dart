import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskerpro/model/task_list.dart';
import 'package:vibration/vibration.dart';

class TaskSettingsPage extends StatefulWidget {
  var taskId;
  TaskSettingsPage(String id) {
    taskId = id;
  }
  @override
  State<StatefulWidget> createState() {
    return _TaskSettingsPageState(taskId);
  }
}

class _TaskSettingsPageState extends State<TaskSettingsPage> {
  var taskId;
  var priority;
  _TaskSettingsPageState(String taskId) {
    this.taskId = taskId;
  }
  final TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TaskList tasks = Provider.of<TaskList>(context);
    txtController.text = tasks.getTaskById(taskId).title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: txtController,
            ),
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text("Priority"),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: prioritySelect(tasks),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Row(
        children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () async {
                    if (await Vibration.hasAmplitudeControl() != null) {
                      Vibration.vibrate(duration: 200, amplitude: 128);
                    }
                    tasks
                        .getTaskById(taskId)
                        .updateTask(txtController.text, priority);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'))),
          Expanded(
              child: ElevatedButton(
                  onPressed: () async {
                    if (await Vibration.hasAmplitudeControl() != null) {
                      Vibration.vibrate(duration: 200, amplitude: 128);
                    }
                    tasks.removeTask(taskId);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Delete'))),
        ],
      ),
    );
  }

  Widget prioritySelect(TaskList tasks) {
    const List<int> list = <int>[1, 2, 3, 4, 5];
    priority = tasks.getTaskById(taskId).priority;
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
        tasks.getTaskById(taskId).updateTask(txtController.text, priority);
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
