// Task model — represents a single task in the app
// This is a plain Dart class with a constructor

class Task {
  String title;
  String description;
  String category; // School, Personal, Health, Work
  String priority; // Low, Medium, High
  DateTime dueDate;
  bool isCompleted;

  // Constructor: named parameters, all required except isCompleted
  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false, // defaults to false when not provided
  });
}