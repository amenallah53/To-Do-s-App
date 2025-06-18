import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Task {
  String taskName;
  bool isDone;

  Task({
    required this.taskName,
    required this.isDone,
  });

  factory Task.fromMap(Map task) {
    return Task(
      taskName: task["taskName"],
      isDone: task["isDone"],
    );
  }

  Map toMap() {
    return {
      "taskName": taskName,
      "isDone": isDone,
    };
  }
}

List getTasks(String category) {
  if (!Hive.isBoxOpen(category)) {
    return [];
  }
  Box? box = Hive.box(category);
  return box.values.toList();
}

// Create or add single data in hive
void addTask(String category, String data, bool state) {
  var task = Task(taskName: data, isDone: state);
  var box = Hive.box(category);
  box.add(task.toMap());

  //userBox.addAll(data);
}

void updateTask(String category, String newData, bool newDone, int index) {
  var box = Hive.box(category);
  var newTask = Task(taskName: newData, isDone: newDone);
  box.putAt(index, newTask.toMap());
}

void deleteData(String category, int index) {
  var box = Hive.box(category);
  box.deleteAt(index);
}

bool boxIsEmpty(String category) {
  if (!Hive.isBoxOpen(category)) {
    return true; // Consider empty if the box isn't opened
  }
  var box = Hive.box(category);
  return box.isEmpty;
}

//-------------------------------------------------------------------------------------------------------

class CategoryBox {
  String categoryName;
  String description;
  Color colorStart;
  Color colorEnd;

  CategoryBox(
      {required this.categoryName,
      this.description = "",
      required this.colorStart,
      required this.colorEnd});

  factory CategoryBox.fromMap(Map category) {
    return CategoryBox(
        categoryName: category["categoryName"],
        description: category["description"],
        colorStart: Color(category["colorStart"]),
        colorEnd: Color(category["colorEnd"]));
  }

  Map toMap() {
    return {
      "categoryName": categoryName,
      "description": description,
      "colorStart": colorStart.value,
      "colorEnd": colorEnd.value
    };
  }
}

List<CategoryBox> getCategories(String category) {
  if (!Hive.isBoxOpen(category)) {
    return [];
  }
  Box box = Hive.box(category);
  return box.values.map((category) => CategoryBox.fromMap(category)).toList();
}

// Create or add single data in hive
void addCategories(String categoryName, String description, Color colorStart,
    Color colorEnd) async {
  var category = CategoryBox(
      categoryName: categoryName,
      description: description,
      colorStart: colorStart,
      colorEnd: colorEnd);
  var box = Hive.box('categories');
  box.add(category.toMap());
}

void updateCategory(String newCategoryName, String newDescription,
    Color colorStart, Color colorEnd, int index) {
  var box = Hive.box('categories');
  var newCategory = CategoryBox(
      categoryName: newCategoryName,
      description: newDescription,
      colorStart: colorStart,
      colorEnd: colorEnd);
  box.putAt(index, newCategory.toMap());
}

void deleteCategory(String categoryName, int index) async {
  var box = Hive.box(categoryName);
  box.deleteAt(index);
}

Future<void> deleteHiveBox(String boxName) async {
  // Check if the box is open
  if (Hive.isBoxOpen(boxName)) {
    var box = Hive.box(boxName);
    await box.close(); // Close the box before deleting
  }

  // Delete the entire box from storage
  await Hive.deleteBoxFromDisk(boxName);

  print("$boxName has been deleted.");
}
