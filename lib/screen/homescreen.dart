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
  FocusNode searchFocusNode = FocusNode();
  bool searchFocused = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() => searchFocused = searchFocusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Notes App",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Consumer<NoteProvider>(
                      builder: (_, value, __) => AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.symmetric(
                            horizontal: searchFocused ? 4 : 0),
                        child: SearchBar(
                          focusNode: searchFocusNode,
                          leading: const Icon(Icons.search),
                          controller: searchController,
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          hintText: 'Search Notes',
                          onChanged: value.searchNotes,
                        ),
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
                  builder: (_, value, __) => value.filteredNotes.isEmpty
                      ? const Center(
                          child: AnimatedOpacity(
                            opacity: 1,
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              "No Notes Found",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: value.filteredNotes.length,
                          itemBuilder: (context, index) {
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration:
                                  Duration(milliseconds: 400 + (index * 70)),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset:
                                        Offset(0, 20 * (1 - value)), // slide up
                                    child: child,
                                  ),
                                );
                              },
                              child: GestureDetector(
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
                              ),
                            );
                          }),
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
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 350),
              pageBuilder: (_, animation, __) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: const CreateNoteScreen(),
                  ),
                );
              },
            ),
          );
        },
        shape: const CircleBorder(),
        tooltip: 'Create Note',
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
