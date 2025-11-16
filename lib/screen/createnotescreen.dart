import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/provider/note_provider.dart';
import 'package:notesapp/utils/priority.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Create Notes")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 16),

            Expanded(
              child: TextFormField(
                controller: bodyController,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "Your note",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _saveNote(context),
        child: const Icon(Icons.save),
      ),
    );
  }

  void _saveNote(BuildContext context) {
    // Simple validation
    if (titleController.text.isEmpty ||
        bodyController.text.isEmpty ||
        _priority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final provider = context.read<NoteProvider>();

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: titleController.text,
      body: bodyController.text,
      created: DateTime.now(),
      priority: _priority!.name,
    );

    provider.addNote(note);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Note saved"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
