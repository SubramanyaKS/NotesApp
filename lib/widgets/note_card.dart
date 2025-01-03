import 'package:flutter/material.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:notesapp/models/priority.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.index});

  final Note note;
  final int index;


  @override
  Widget build(BuildContext context) {
    Color c = Colors.green;
    if(note.priority==Priority.high.name){
      c=Colors.red;
    }
    if(note.priority==Priority.medium.name){
      c=Colors.yellow;
    }

    return Card(
      color: Colors.orange[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.deepPurpleAccent),),
                  const SizedBox(height: 10,),
                  Text(note.body,
                    style: const TextStyle(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,),
                  const SizedBox(height: 10,),
                  Text("Created on: ${note.created.toString().substring(0,10)}")
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete,color: Colors.red,size: 40),
              onPressed: () {
                //   delete note
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Want to delete this note?"),
                    content: Text("This ${note.title} will be deleted and cannot be recovered!Are you sure to delete this?"),
                    actions: [
                      TextButton(onPressed: (){context.read<NoteData>().removeNote(note);Navigator.of(context).pop();}, child: const Text("Delete")),
                      TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("Cancle"))
                    ],
                  );
                }
                );
              },
            ),
            Icon(Icons.circle_rounded,color: c,),
          ],
        ),
      ),
    );
  }
}
