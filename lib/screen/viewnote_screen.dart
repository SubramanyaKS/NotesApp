import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/provider/note_provider.dart';
import 'package:notesapp/utils/utils.dart';
import 'package:notesapp/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

import '../utils/priority.dart';

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
  bool editable = false;
  Priority? _priority;

  @override
  void initState() {
    super.initState();
    // Initialize _priority once during widget initialization
    titleController.text = widget.note.title;
    bodyController.text = widget.note.body;
    _priority = priorityFromString(widget.note.priority);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (editable == false) {
                setState(() {
                  editable = !editable;
                });
              }
            },
            icon: const Icon(
              Icons.edit_sharp,
              color: Colors.orange,
            ),
          ),
        ],
        title: const Text("Notes App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
            const SizedBox(
              height: 18,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Priority:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            RadioGroup<Priority>(
              groupValue: _priority,
              onChanged: (value) {
                setState(() => _priority = value);
              },
              child: const Row(
                children: [
                  Expanded(
                    child: RadioListTile<Priority>(
                      title: Text(
                        'Low',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: Priority.low,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Priority>(
                      title: Text(
                        'Medium',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: Priority.medium,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Priority>(
                      title: Text(
                        'High',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: Priority.high,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
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
      floatingActionButton: editable
          ? Consumer<NoteProvider>(
              builder: (context, provider, _) => FloatingActionButton(
                backgroundColor: Colors.orange,
                splashColor: Colors.orangeAccent,
                onPressed: () => _saveNote(provider),
                tooltip: 'Save Note',
                child: const Icon(Icons.save),
              ),
            )
          : null,
    );
  }

  void _saveNote(NoteProvider provider) {
    if (titleController.text.isEmpty || bodyController.text.isEmpty) return;

    provider.updateNote(
      widget.index,
      titleController.text,
      bodyController.text,
      _priority!.name,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: CustomToast(
          message: "Changes has been saved",
          color: Colors.green,
          icons: Icons.check,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    Navigator.pop(context);
  }
}
