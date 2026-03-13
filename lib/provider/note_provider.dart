import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteProvider extends ChangeNotifier {
  Box<Note>? _noteBox;
  List<Note> _filteredNotes = [];

  NoteProvider() {
    if (Hive.isBoxOpen('notes')) {
      _noteBox = Hive.box<Note>('notes');
    } else {
      // Try to open the box if not yet open (e.g. hot reload timing race).
      Hive.openBox<Note>('notes').then((box) {
        _noteBox = box;
        notifyListeners();
      }).catchError((error) {
        debugPrint('Hive box open failed in NoteProvider: $error');
      });
    }
  }

  List<Note> get allNotes => _noteBox?.values.toList() ?? [];
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
    if (_noteBox == null) return;
    _noteBox!.add(note);
    _filteredNotes = allNotes;
    notifyListeners();
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
    if (_noteBox == null) return;
    _noteBox!.deleteAt(index);
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void removeNote(Note note) {
    if (_noteBox == null) return;
    final key = note.key;
    if (key != null && _noteBox!.containsKey(key)) {
      _noteBox!.delete(key);
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
