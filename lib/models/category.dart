import 'package:flutter/material.dart';
import 'package:to_dos/hive_functions.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryModel extends StatefulWidget {
  final String name;
  final String description;
  final Color colorStart;
  final Color colorEnd;
  final VoidCallback onSetState;

  CategoryModel(
      {super.key,
      required this.name,
      required this.description,
      required this.colorStart,
      required this.colorEnd,
      required this.onSetState});

  @override
  State<CategoryModel> createState() => _CategoryModelState();
}

class _CategoryModelState extends State<CategoryModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.colorStart,
            widget.colorEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.colorStart.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.name.length <= 10 ? 39 : 30,
                      fontWeight: FontWeight.w700),
                )),
                Flexible(
                    child: Text(
                  widget.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.description.length <= 50 ? 16 : 12,
                      fontWeight: FontWeight.w300),
                )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                List<CategoryBox> categoriesList = getCategories('categories');
                int index = 0;
                while (categoriesList[index].categoryName != widget.name) {
                  index++;
                }
                if (value == "modify") {
                  print("Modify selected");
                  showDialog(
                      context: context,
                      builder: (context) {
                        var controller1 =
                            TextEditingController(text: widget.name);
                        var controller2 =
                            TextEditingController(text: widget.description);
                        return AlertDialog(
                          title: Center(
                            child: Text(
                              "Modify Category",
                              style: TextStyle(color: widget.colorStart),
                            ),
                          ),
                          content: SizedBox(
                            height: 152,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: controller1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: widget.colorStart, width: 2),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: "Modify Category",
                                    floatingLabelStyle:
                                        TextStyle(color: widget.colorStart),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: controller2,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: widget.colorStart, width: 2),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: "Modify description",
                                    floatingLabelStyle:
                                        TextStyle(color: widget.colorStart),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                if (controller1.text != "") {
                                  List tasks = getTasks(widget.name);
                                  print(tasks);
                                  print(categoriesList.length);
                                  updateCategory(
                                      controller1.text,
                                      controller2.text,
                                      widget.colorStart,
                                      widget.colorEnd,
                                      index);
                                  await Hive.openBox(controller1.text);
                                  if (controller1.text != widget.name) {
                                    for (var i = 0; i < tasks.length; i++) {
                                      deleteCategory(widget.name, index);
                                    }
                                    tasks.forEach(
                                      (element) {
                                        var task = Task.fromMap(element);
                                        addTask(controller1.text, task.taskName,
                                            task.isDone);
                                      },
                                    );
                                    await deleteHiveBox(widget.name);
                                  }
                                  widget.onSetState();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(color: widget.colorStart),
                              ),
                            ),
                          ],
                        );
                      });
                } else if (value == "delete") {
                  print("Delete selected");
                  deleteCategory('categories', index);
                  await deleteHiveBox(widget.name);
                  widget.onSetState();
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "modify",
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.black),
                      title: Text("Modify"),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "delete",
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ];
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
