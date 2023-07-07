import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int priority;

  @HiveField(3)
  bool isDone;

  Task(this.title, this.priority, this.isDone) : id = Uuid().v4() {}

  void markAsDone() {
    isDone = true;
  }

  void markAsTodo() {
    isDone = false;
  }

  void setPriority(int priority) {
    this.priority = priority;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void updateTask(String? title, int? priority) {
    this.priority = priority!;
    this.title = title!;
    //save();
  }
}
