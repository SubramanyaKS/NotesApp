import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/provider/note_provider.dart';
import 'package:notesapp/utils/priority.dart';
import 'package:notesapp/widgets/custom_toast.dart';
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
  bool pinned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Notes"),actions: [
        IconButton(onPressed: ()=>{ setState(() {
          pinned = !pinned;
        })}, icon: Icon(pinned?Icons.push_pin_sharp:Icons.push_pin_outlined),color: Colors.red,),
      ],),
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
    if (titleController.text.isEmpty ||
        bodyController.text.isEmpty ||
        _priority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomToast(
            message: "Please complete all fields",
            color: Colors.red,
            icons: Icons.warning,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
      pinned: pinned
    );

    provider.addNote(note);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: CustomToast(
          message: "Note Saved",
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
