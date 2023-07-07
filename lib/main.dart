import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskerpro/pages/tasklist_page.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dcdg/dcdg.dart';

import 'model/task_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.initFlutter('hive_db');

  await Hive.openBox('tasks');

  TaskList tasks = TaskList();
  runApp(TaskerPro(tasks));
}

class TaskerPro extends StatelessWidget {
  final TaskList tasks;
  const TaskerPro(this.tasks, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => tasks,
      child: MaterialApp(
        title: 'TaskerPro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: TaskListPage(),
      ),
    );
  }
}
