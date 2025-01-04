import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteData extends ChangeNotifier {
  final Box<Note> _noteBox = Hive.box<Note>('notes');
  List<Note> _filteredNotes = [];

  List<Note> get allNotes => _noteBox.values.toList();
  List<Note> get filteredNotes => _filteredNotes.isEmpty ? allNotes : _filteredNotes;

  void searchNotes(String query) {
    if (query.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = allNotes
          .where((note) =>
      note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.body.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if(_filteredNotes.isEmpty){
        _filteredNotes = [];
      }
    }
    notifyListeners();
  }

  void addNote(Note note) {
    _noteBox.add(note);
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void updateNote(int index, String title, String body, String priority) {
    Note updatedNote = _noteBox.getAt(index)!;
    updatedNote.title = title;
    updatedNote.body = body;
    updatedNote.priority = priority;
    _noteBox.putAt(index, updatedNote);
    _filteredNotes = allNotes;
    notifyListeners();
  }

  void removeNoteAt(int index) {
    _noteBox.deleteAt(index);
    notifyListeners();
  }

  void removeNote(Note note) {
    final index = _noteBox.values.toList().indexOf(note);
    if (index != -1) {
      _noteBox.deleteAt(index);
      _filteredNotes = allNotes;
      notifyListeners();
    }
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

    _filteredNotes = notesToSort; // Ensure sorting is applied
    notifyListeners();
  }
}