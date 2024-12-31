import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/screen/homescreen.dart';

class ViewNoteScreen extends StatefulWidget {
  final Note note;
  final int,index;
  const ViewNoteScreen({super.key, required this.note, this.int, this.index});

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool editable=false;

  @override
  Widget build(BuildContext context) {
    titleController.text=widget.note.title;
    bodyController.text=widget.note.body;


    return Consumer<NoteData>(builder: (context,value,child)=>
        Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  if(editable==false) {
                    setState(() {
                      editable = !editable;
                    });
                  }
                },
                icon: const Icon(Icons.edit_sharp,color: Colors.orange,),
              ),
            ],
            title: Text("Notes App"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  readOnly: !editable,
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                  ),
                ),
                SizedBox(height: 18,),
                TextFormField(
                  readOnly: !editable,
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
              value.updateNote(widget.index,titleController.text, bodyController.text);
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Edited changes in note as been saved"),
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
