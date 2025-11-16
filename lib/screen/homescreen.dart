import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/provider/note_provider.dart';
import 'package:notesapp/screen/createnotescreen.dart';
import 'package:notesapp/screen/viewnote_screen.dart';
import 'package:notesapp/utils/utils.dart';
import 'package:notesapp/widgets/note_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Note> displayNotes;
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height:20),
              const Center(
                child: Text(
                  "Notes App",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ),
              const SizedBox(height:20),
              Row(
                children: [
                  Expanded(
                    child: Consumer<NoteProvider>(
                      builder: (_, value, __) => SearchBar(
                        leading: const Icon(Icons.search),
                        controller: searchController,
                        backgroundColor: const WidgetStatePropertyAll(Colors.white),
                        hintText: 'Search Notes',
                        onChanged: value.searchNotes,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.sort),
                      tooltip: 'Sort',
                      onSelected: (val) {
                        final provider = context.read<NoteProvider>();
        
                        if (val == 'Title Asc') {
                          provider.sortNotes('title', true);
                        } else if (val == 'Title Desc') {
                          provider.sortNotes('title', false);
                        } else if (val == 'Index Asc') {
                          provider.sortNotes('index', true);
                        } else if (val == 'Index Desc') {
                          provider.sortNotes('index', false);
                        }
                      },
                      itemBuilder: (context) {
                        return sortOptions.entries.map((entry) {
                          return PopupMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Consumer<NoteProvider>(
                  builder: (_, value, __) => ListView.builder(
                    itemCount: value.filteredNotes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewNoteScreen(
                              note: value.filteredNotes[index],
                              index: index,
                            ),
                          ),
                        ),
                        child: NoteCard(
                          note: value.filteredNotes[index],
                          index: index,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        elevation: 5,
        hoverColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateNoteScreen()),
          );
        },
        shape: const CircleBorder(),
        tooltip: 'Create Note',
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
  
}
