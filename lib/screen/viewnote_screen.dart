import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:provider/provider.dart';

import '../models/priority.dart';

class ViewNoteScreen extends StatefulWidget {
  final Note note;
  final dynamic index;
  const ViewNoteScreen({super.key, required this.note, this.index});

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool editable=false;
  Priority? _priority;

  @override
  void initState() {
    super.initState();
    // Initialize _priority once during widget initialization
    _priority = priorityFromString(widget.note.priority);
  }

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
            title: const Text("Notes App"),
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
                const SizedBox(height: 18,),
                const Text("Priority:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: ListTile(
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        // dense: true,
                        title: const Text('Low',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                        leading: Radio<Priority>(
                          activeColor: Colors.greenAccent,
                          value: Priority.low,
                          groupValue: _priority,
                          onChanged: (Priority? value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Medium',style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold),),
                        leading: Radio<Priority>(
                          activeColor: Colors.yellowAccent,
                          value: Priority.medium,
                          groupValue: _priority,
                          onChanged: (Priority? value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('High',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                        leading: Radio<Priority>(
                          activeColor: Colors.redAccent,
                          value: Priority.high,
                          groupValue: _priority,
                          onChanged: (Priority? value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18,),
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
              value.updateNote(widget.index,titleController.text, bodyController.text,_priority!.name);
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Edited changes in note as been saved"),
                  actions: [
                    TextButton(onPressed: (){Navigator.of(context).pop();Navigator.pop(context);}, child: const Text("OK"))
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
  Priority? priorityFromString(String priorityString) {
    try {
      return Priority.values.byName(priorityString);
    } catch (e) {
      return null; // Handle invalid strings gracefully
    }
  }
}
