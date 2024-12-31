import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/models/note_data.dart';
import 'package:notesapp/screen/createnotescreen.dart';
import 'package:notesapp/screen/viewnote_screen.dart';
import 'package:notesapp/widgets/note_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
        builder: (context,value,child)=>Scaffold(
          backgroundColor: CupertinoColors.systemBackground,
          appBar: AppBar(
            title: Text("Notes App"),
            backgroundColor: Colors.orange[100],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(child: Text("All Notes",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.orange),)),
              Expanded(
                child: ListView.builder(itemCount: value.getAllNotes().length,
                  itemBuilder: (context,index){
                  return
                  GestureDetector(
                    onTap:()=> Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewNoteScreen(note:value.getAllNotes()[index],index:index)),
                    ),
                      child: NoteCard(note: value.getAllNotes()[index], index: index));
                  },
                ),
              )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
            elevation: 5,
            hoverColor: Colors.orangeAccent,
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateNoteScreen()),
              );
            },
            shape: CircleBorder(),
            tooltip: 'Create Note',
            child: const Icon(Icons.edit_outlined),
          ),
        ),
    );

  }
}
