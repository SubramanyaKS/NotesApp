import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteProvider extends ChangeNotifier {
  late Box<Note> _noteBox = Hive.box<Note>('notes');
  List<Note> _filteredNotes = [];

  // NoteProvider() {
    // Since we ensure the box is open in main.dart, we can safely get it here
    // try {
    //   _noteBox = Hive.box<Note>('notes');
    //   debugPrint('NoteProvider initialized successfully');
    // } catch (e) {
    //   debugPrint('Error getting Hive box in NoteProvider: $e');
    //   // Try to open the box if it's not open
    //   Hive.openBox<Note>('notes').then((box) {
    //     _noteBox = box;
    //     debugPrint('NoteProvider box opened successfully');
    //     notifyListeners();
    //   }).catchError((error) {
    //     debugPrint('Failed to open box in NoteProvider: $error');
    //   });
    // }
  // }

  List<Note> get allNotes => _noteBox.values.toList();
  List<Note> get filteredNotes =>
      _filteredNotes.isEmpty ? allNotes : _filteredNotes;

  void searchNotes(String query) {
    if (query.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = allNotes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.body.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addNote(Note note) {
    debugPrint("Adding note: ${note.title}");
    _noteBox.add(note);
    _filteredNotes = allNotes;
    notifyListeners();
    debugPrint("Note added successfully, total notes: ${allNotes.length}");
  }

  void updateNote(int index, String title, String body, String priority) {
    if (_noteBox == null) return;
    final note = _noteBox!.getAt(index);
    if (note == null) return;
    note.title = title;
    note.body = body;
    note.priority = priority;
    note.save();
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void updateNoteByNote(Note note, String title, String body, String priority) {
    note.title = title;
    note.body = body;
    note.priority = priority;
    note.save();
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void removeNoteAt(int index) {
    _noteBox.deleteAt(index);
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void removeNote(Note note) {
    final key = note.key;
    if (key != null && _noteBox.containsKey(key)) {
      _noteBox.delete(key);
      _filteredNotes = allNotes;
      notifyListeners();
    }
  }

  void pinNote(Note note) {
    note.pinned = !note.pinned;
    note.save();
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void sortNotes(String field, bool ascending) {
    List<Note> notesToSort = filteredNotes.isEmpty ? allNotes : _filteredNotes;

    notesToSort.sort((a, b) {
      switch (field) {
        case 'title':
          return ascending
              ? a.title.toLowerCase().compareTo(b.title)
              : b.title.toLowerCase().compareTo(a.title);
        case 'index':
          return ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id);
        default:
          return 0;
      }
    });

    _filteredNotes = notesToSort;
    notifyListeners();
  }
}
