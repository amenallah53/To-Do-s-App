import 'package:flutter/material.dart';
import '../models/category.dart';
import 'category_page.dart';
import '../hive_functions.dart';
import '../models/appbar.dart';
import '../models/custom_add_button.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  List<CategoryBox> categoryList;
  HomePage({required this.categoryList, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<Color>> list_color = [
    [Colors.red, Colors.redAccent],
    /*[Colors.blue, Colors.blueAccent],*/
    /*[Colors.greenAccent, Colors.green],*/
    [Colors.orange, Colors.deepOrangeAccent],
    [Colors.purple, Colors.deepPurpleAccent],
    /*[Colors.teal, Colors.cyanAccent],*/
    [Colors.pink, Colors.pinkAccent],
    [Colors.indigo, Colors.blueAccent],
    /*[Colors.brown, Colors.orangeAccent],*/
    /*[Colors.grey, Colors.blueGrey],*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "To Do's",
          colorStart: Color(0xFFD1219F),
          colorEnd: Color(0xFFC5008D),
        ),
        body: ListView.builder(
            itemCount: widget.categoryList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: CategoryModel(
                  name: widget.categoryList[index].categoryName,
                  description: widget.categoryList[index].description,
                  colorStart: widget.categoryList[index].colorStart,
                  colorEnd: widget.categoryList[index].colorEnd,
                  onSetState: () {
                    setState(() {
                      widget.categoryList =
                          getCategories('categories'); // Refresh list
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                              categoryName:
                                  widget.categoryList[index].categoryName,
                              colorStart: widget.categoryList[index].colorStart,
                              colorEnd: widget.categoryList[index].colorEnd,
                            )),
                  );
                },
              );
            }),
        floatingActionButton: CustomFloatActionButton(
            categoryList: widget.categoryList,
            list_color: list_color,
            onSetState: () {
              setState(() {
                widget.categoryList =
                    getCategories('categories'); // Refresh list
              });
            }));
  }
}
