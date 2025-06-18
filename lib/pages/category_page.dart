import 'package:flutter/material.dart';
import 'package:to_dos/hive_functions.dart';
import '../models/appbar.dart';
import 'package:lottie/lottie.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  final Color colorStart;
  final Color colorEnd;
  const CategoryPage(
      {required this.categoryName,
      required this.colorStart,
      required this.colorEnd,
      super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  List categoryData = [];

  late final AnimationController _animation_controller;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
    _animation_controller = AnimationController(vsync: this)
      ..value = 0.5
      ..addListener(() {
        setState(() {
          // Rebuild the widget at each frame to update the "progress" label.
        });
      });
  }

  // Load tasks from Hive box and update cinemaData list
  void loadTasks() {
    setState(() {
      categoryData =
          boxIsEmpty(widget.categoryName) ? [] : getTasks(widget.categoryName);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.categoryName,
          colorStart: widget.colorStart,
          colorEnd: widget.colorEnd,
          leadingState: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 30.0, bottom: 10.0),
                child: TextField(
                  onSubmitted: (value) {
                    addTask(widget.categoryName, _controller.text, false);
                    _controller.clear();
                    loadTasks(); // Update UI
                  },
                  controller: _controller,
                  style: TextStyle(
                    fontSize: 20, /*fontWeight: FontWeight.w800*/
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter a task to do ...",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.colorStart,
                        width: 2,
                      ), // Red when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.grey), // Default state border
                    ),
                  ),
                ),
              ),
              Center(
                child: Lottie.asset(
                  'assets/animation.json',
                  //width: 250,
                  //height: 250,
                  fit: BoxFit.fill,
                  controller: _animation_controller,
                  onLoaded: (composition) {
                    setState(() {
                      _animation_controller.duration = composition.duration;
                      _animation_controller.forward();
                    });
                  },
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: CustomAppBar(
            title: widget.categoryName,
            colorStart: widget.colorStart,
            colorEnd: widget.colorEnd,
            leadingState: true,
          ),
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 30.0, bottom: 10.0),
                child: TextField(
                  onSubmitted: (value) {
                    addTask(widget.categoryName, _controller.text, false);
                    _controller.clear();
                    loadTasks(); // Update UI
                  },
                  controller: _controller,
                  style: TextStyle(
                    fontSize: 20, /*fontWeight: FontWeight.w800*/
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter a task to do ...",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.colorStart,
                        width: 2,
                      ), // Red when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.grey), // Default state border
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 500,
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 12.0, top: 10.0, bottom: 10.0),
                      itemCount: categoryData.length,
                      itemBuilder: (context, index) {
                        var task = Task.fromMap(categoryData[index]);
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 15),
                          title: Text(
                            task.taskName,
                            style: TextStyle(
                              fontSize: 18,
                              /*fontWeight: FontWeight.w600,*/
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null, // Strike-through if completed
                            ),
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Delete Task Button
                              IconButton(
                                icon: Icon(Icons.delete_forever_outlined),
                                color: widget.colorStart,
                                onPressed: () {
                                  deleteData(widget.categoryName, index);
                                  loadTasks(); // Refresh the list after deletion
                                },
                              ),
                              // Checkbox Button for Marking Task as Done or Not Done
                              IconButton(
                                icon: Icon(
                                  task.isDone
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                ),
                                color: widget.colorStart,
                                onPressed: () {
                                  // Toggle the task completion status
                                  setState(() {
                                    task.isDone = !task.isDone;
                                  });

                                  // Update the task in Hive
                                  updateTask(
                                    widget.categoryName,
                                    task.taskName,
                                    task.isDone,
                                    index,
                                  );
                                  loadTasks(); // Refresh the task list
                                },
                              ),
                            ],
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                var controller =
                                    TextEditingController(text: task.taskName);
                                return AlertDialog(
                                  title: Text(
                                    "Edit Task",
                                    style: TextStyle(color: widget.colorStart),
                                  ),
                                  content: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: widget.colorStart,
                                            width: 2), // Red when focused
                                      ),
                                    ),
                                    onSubmitted: (value) {
                                      updateTask(widget.categoryName,
                                          controller.text, task.isDone, index);
                                      Navigator.pop(context);
                                      loadTasks();
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        updateTask(
                                            widget.categoryName,
                                            controller.text,
                                            task.isDone,
                                            index);
                                        Navigator.pop(context);
                                        loadTasks();
                                      },
                                      child: Text(
                                        "Update",
                                        style:
                                            TextStyle(color: widget.colorStart),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }))
            ],
          )));
    }
  }
}
