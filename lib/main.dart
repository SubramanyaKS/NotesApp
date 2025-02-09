import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:notesapp/screen/homescreen.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter binding is initialized

  try {
    await Hive.initFlutter(); // Initialize Hive
    Hive.registerAdapter(NoteAdapter()); // Register your NoteAdapter
    await Hive.openBox<Note>('notes'); // Open the Hive box
  } catch (e) {
    debugPrint('Hive initialization error: $e');
  }

  runApp(const MyApp()); // Run the app

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>NoteData(),
    builder: (context,child)=>MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    ),);
  }
}

