import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:notesapp/screen/homescreen.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(builder: (context,value,child)=>
        Scaffold(
          appBar: AppBar(
            title: Text("Create Notes"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                  ),
                ),
                SizedBox(height: 18,),
                TextFormField(
                  maxLines: 10,
                  controller: bodyController,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your note",
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            splashColor: Colors.orangeAccent,
            onPressed: (){
              if(titleController.text.isEmpty){
                return;
              }
              if(bodyController.text.isEmpty){
                return;
              }
              final note = Note(id: value.getAllNotes().length<=0?0:value.getAllNotes().length+1, title: titleController.text, body: bodyController.text,created:DateTime.now());
              value.addNote(note);
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Note as been saved"),
                  actions: [
                    TextButton(onPressed: (){Navigator.of(context).pop();Navigator.pop(context);}, child: Text("OK"))
                  ],
                );
              }
              );
            },
            tooltip: 'Save Note ',
            child: const Icon(Icons.save),
          ),
        ),
    );

  }
}
