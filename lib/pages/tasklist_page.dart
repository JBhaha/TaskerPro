import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:taskerpro/pages/addtask_page.dart';
import 'package:taskerpro/pages/tasksettings_page.dart';
import 'package:vibration/vibration.dart';

import '../model/task_list.dart';

class TaskListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskListPageState();
  }
}

class _TaskListPageState extends State<TaskListPage> {
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
  }

  void navigateToOtherPage() {
    // Use Flutter's navigation system to navigate to a different page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage()),
    );
  }

  /*@override
  void didUpdateWidget(TaskListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the widget is updated (navigated back)
    if (widget != oldWidget) {
      // Re-enable shake detection
      setState(() {
        _isShakeEnabled = true;
      });
    }
  }*/

  @override
  void dispose() {
    // Dispose the shake detector
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasks = Provider.of<TaskList>(context);

    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setTasksToDone(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("TaskerPro"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("To-do"),
            Expanded(
              child: todoTasks(context, tasks),
            ),
            const Text("Done"),
            Expanded(
              child: doneTasks(context, tasks),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await Vibration.hasAmplitudeControl() != null) {
            Vibration.vibrate(duration: 200, amplitude: 128);
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTaskPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget todoTasks(BuildContext context, TaskList tasks) {
    //var tasks = Provider.of<TaskList>(context);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.getTodoList().length,
      itemBuilder: (context, index) => Card(
        color: Colors.amber,
        child: ListTile(
          title: Text(tasks.getTodoList()[index].title),
          subtitle: Text(
              "Priority: " + tasks.getTodoList()[index].priority.toString()),
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            TaskSettingsPage(tasks.getTodoList()[index].id)))
                .then((value) => redrawPage());
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    tasks.getTodoList()[index].markAsDone();
                    redrawPage();
                  },
                  icon: const Icon(Icons.radio_button_unchecked)),
            ],
          ),
        ),
      ),
    );
  }

  Widget doneTasks(BuildContext context, TaskList tasks) {
    //var tasks = Provider.of<TaskList>(context);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.getDoneList().length,
      itemBuilder: (context, index) => Card(
        color: Colors.grey,
        child: ListTile(
          title: Text(tasks.getDoneList()[index].title),
          subtitle: Text(
              "Priority: " + tasks.getDoneList()[index].priority.toString()),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        TaskSettingsPage(tasks.getDoneList()[index].id)));
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    tasks.getDoneList()[index].markAsTodo();
                    redrawPage();
                  },
                  icon: const Icon(Icons.radio_button_checked)),
            ],
          ),
        ),
      ),
    );
  }

  void setTasksToDone(BuildContext context) {
    var tasks = Provider.of<TaskList>(context, listen: false);
    for (var i = 0; i <= tasks.getTodoList().length; i++) {
      tasks.getTaskList()[i].markAsDone();
    }
    redrawPage();
  }

  void redrawPage() {
    setState(() {
      //nothing to do, only redraw
    });
  }
}
