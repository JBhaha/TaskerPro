import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskerpro/model/task.dart';

class TaskList extends ChangeNotifier {
  late Box taskBox;

  List<Task> tasks = [
    Task("First Task", 2, false),
    Task("Second Task", 4, false),
    Task("Third Task", 5, true),
  ];

  /*void sortList() {
    tasks.sort((a, b) => {a.priority.compareTo(b.priority)});
  }
  
  

  void initData() {
    getBox().add(Task("title", 2, false));
    getBox().add(Task("title", 2, false));
    getBox().add(Task("title", 2, false));
    for (var i = 0; i < getBox().length; i++) {
      tasks.add(getBox().getAt(i));
    }
  }*/

  Box getBox() {
    return Hive.box('tasks');
  }

  Task getTaskById(String id) {
    for (Task element in tasks) {
      if (element.id == id) {
        return element;
      }
    }
    return Task("Not found", 1, false);
  }

  List<Task> getTaskList() {
    return tasks;
  }

  List<Task> getTodoList() {
    List<Task> todos = [];
    for (Task element in tasks) {
      if (element.isDone == false) {
        todos.add(element);
      }
    }

    return todos;
  }

  List<Task> getDoneList() {
    List<Task> done = [];
    for (var element in tasks) {
      if (element.isDone == true) {
        done.add(element);
      }
    }
    return done;
  }

  void addTask(Task task) {
    tasks.add(task);
    //getBox().add(task);
    notifyListeners();
  }

  void removeTask(String uuid) {
    tasks.removeWhere((element) => element.id == uuid);
    notifyListeners();
  }
}
