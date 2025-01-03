import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:notesapp/models/priority.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {

  Priority? _priority = Priority.low;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(builder: (context,value,child)=>
        Scaffold(
          appBar: AppBar(
            title: const Text("Create Notes"),
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
                  maxLines: 18,
                  controller: bodyController,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    border:InputBorder.none,
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
              final note = Note(id: value.allNotes.isEmpty?0:value.allNotes.length+1, title: titleController.text, body: bodyController.text,created:DateTime.now(),priority: _priority!.name);
              value.addNote(note);
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Note as been saved"),
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
}
