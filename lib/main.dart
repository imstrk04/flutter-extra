import 'package:flutter/material.dart';
import 'todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:  TodoScreennnnn(),
    );
  }
}


// image_picker: ^1.0.4
// provider: ^6.1.0
// shared_preferences: ^2.2.2
+