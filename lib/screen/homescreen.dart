import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/provider/note_provider.dart';
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
  // List<Note> displayNotes;
  @override
  Widget build(BuildContext context) {

    return Consumer<NoteProvider>(
        builder: (context,value,child)=>Scaffold(
          backgroundColor: CupertinoColors.systemBackground,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                PopupMenuButton<String>(
                  tooltip: 'Sort',
                  onSelected: (val) {
                    if (val == 'Title Asc') {
                      value.sortNotes('title', true);
                    } else if (val == 'Title Desc') {
                      value.sortNotes('title', false);
                    } else if (val == 'Index Asc') {
                      value.sortNotes('index', true);
                    } else if (val == 'Index Desc') {
                      value.sortNotes('index', false);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Title Asc', child: Text('Sort by Title Asc')),
                    const PopupMenuItem(value: 'Title Desc', child: Text('Sort by Title Desc')),
                    const PopupMenuItem(value: 'Index Asc', child: Text('Sort by Index Asc')),
                    const PopupMenuItem(value: 'Index Desc', child: Text('Sort by Index Desc')),
                  ],
                ),
              ),
            ],
            title: const Text("Notes App"),
            backgroundColor: Colors.orange[100],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Center(child: Text("All Notes",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.orange),)),
            TextField(
              onChanged: (query) {
                value.searchNotes(query);
              },
              decoration: const InputDecoration(
                labelText: 'Search Notes',
                prefixIcon: Icon(Icons.search),
              ),
            ),
                const SizedBox(height: 18,),

                Expanded(
                  child: ListView.builder(
                    itemCount: value.filteredNotes.length, // Use filteredNotes for the count
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewNoteScreen(
                              note: value.filteredNotes[index], // Use filteredNotes for the note
                              index: index,
                            ),
                          ),
                        ),
                        child: NoteCard(
                          note: value.filteredNotes[index], // Use filteredNotes here as well
                          index: index,
                        ),
                      );
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
            shape: const CircleBorder(),
            tooltip: 'Create Note',
            child: const Icon(Icons.edit_outlined),
          ),
        ),
    );

  }
}
