import 'package:flutter/material.dart';
import 'package:to_dos/pages/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_functions.dart';

//main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('categories');
  final List<CategoryBox> categoriesNames = getCategories('categories');
  for (var i = 0; i < categoriesNames.length; i++) {
    await Hive.openBox(categoriesNames[i].categoryName);
  }
  runApp(MyApp());
}

//root Widget
class MyApp extends StatelessWidget {
  final List<CategoryBox> categoriesNames = getCategories('categories');
  //constructor
  MyApp({super.key});

  //build method
  @override
  Widget build(BuildContext context) {
    // main categories list with them we will build our listwidget

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white), // Change globally
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "To Do's",
      home: HomePage(categoryList: categoriesNames),
    );
  }
}
