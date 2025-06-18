import 'package:flutter/material.dart';
import '../hive_functions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

// ignore: must_be_immutable
class CustomFloatActionButton extends StatefulWidget {
  final List<List<Color>> list_color;
  List<CategoryBox> categoryList;
  final VoidCallback onSetState;

  CustomFloatActionButton(
      {required this.categoryList,
      required this.list_color,
      required this.onSetState,
      super.key});

  @override
  State<CustomFloatActionButton> createState() =>
      _CustomFloatActionButtonState();
}

class _CustomFloatActionButtonState extends State<CustomFloatActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            var controller1 = TextEditingController(text: "");
            var controller2 = TextEditingController(text: "");
            return AlertDialog(
              title: Center(
                child: Text(
                  "Add Category",
                  style: TextStyle(color: Color(0xFFC5008D)),
                ),
              ),
              content: SizedBox(
                height: 152,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFC5008D), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Add Category",
                        floatingLabelStyle: TextStyle(color: Color(0xFFC5008D)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: controller2,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFC5008D), width: 2),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Add description",
                          floatingLabelStyle:
                              TextStyle(color: Color(0xFFC5008D))),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (controller1.text != "") {
                      Random random = new Random();
                      int randomIndex =
                          random.nextInt(widget.list_color.length);
                      addCategories(
                          controller1.text,
                          controller2.text,
                          widget.list_color[randomIndex][0],
                          widget.list_color[randomIndex][1]);
                      await Hive.openBox(controller1.text);
                      widget.onSetState();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(color: Color(0xFFC5008D)),
                  ),
                ),
              ],
            );
          },
        );
      },
      tooltip: 'Add category',
      backgroundColor: Color(0xFFC5008D),
      elevation: 5,
      label: const Text(
        'Add Category',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
