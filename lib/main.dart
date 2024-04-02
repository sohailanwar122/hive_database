import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'hive/home_screen.dart';
import 'hive/note_screen.dart';
import 'models/notes_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory() ;
  Hive.init(directory.path);
  /// open hive in main, now we can access anywhere in the project
  await Hive.openBox('sohail');

  /// register a model to store objects
  Hive.registerAdapter(NotesModelAdapter()) ;
  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NoteScreen(),

      // HomeScreen(),
    );
  }
}

