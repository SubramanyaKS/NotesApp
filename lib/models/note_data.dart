import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteData extends ChangeNotifier {
  final Box<Note> _noteBox = Hive.box<Note>('notes');
  // List <Note> allnotes = List.empty(growable: true);

  List<Note> getAllNotes(){
    return _noteBox.values.toList();
    // return allnotes;
  }

  void addNote(Note note){
    _noteBox.add(note);
    // allnotes.add(note);
    notifyListeners();

  }
  void updateNote(int index, String title, String body) {
    Note updatedNote = _noteBox.getAt(index)!;
    updatedNote.title = title;
    updatedNote.body = body;
    _noteBox.putAt(index, updatedNote);
    // allnotes[index].title = title;
    // allnotes[index].body = body;
    notifyListeners();
  }
  void removeNote(int index){
    _noteBox.deleteAt(index);
    // allnotes.remove(note);
    notifyListeners();
  }

}