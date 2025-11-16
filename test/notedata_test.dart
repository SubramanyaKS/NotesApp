import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/provider/note_provider.dart';

class MockBox<T> extends Mock implements Box<T> {}

class MockHive extends Mock {
  Box<T> box<T>(String name) => MockBox<T>();
}

void main() {
  late MockBox<Note> mockBox;
  late NoteData noteData;
  // Hive.initFlutter();



  setUp(() async{
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>('notes');
    Hive.openBox<Note>('notes');
    mockBox = MockBox<Note>();
    when(Hive.box<Note>('notes')).thenReturn(mockBox);

    noteData = NoteData(); // This uses the internal Hive.box call.
  });

  test('Add a note', () {

    final note = Note(
      id: 1,
      title: 'Test Note',
      body: 'This is a test',
      priority: 'low', created: DateTime.now(),
    );

    when(mockBox.add(note)).thenAnswer((_) async => 0);
    when(mockBox.values).thenReturn([note]);

    noteData.addNote(note);

    verify(mockBox.add(note)).called(1);
    expect(noteData.allNotes.contains(note), true);
  });

  test('Remove a note', () {
    final note = Note(
      id: 1,
      title: 'Test Note',
      body: 'This is a test',
      priority: 'low',
      created: DateTime.now(),
    );

    when(mockBox.values).thenReturn([note]);
    when(mockBox.deleteAt(0)).thenAnswer((_) async {});

    noteData.removeNoteAt(0);

    verify(mockBox.deleteAt(0)).called(1);
    expect(noteData.allNotes.contains(note), false);
  });

  test('Update a note', () {
    final note = Note(
      id: 1,
      title: 'Test Note',
      body: 'This is a test',
      priority: 'low',
      created: DateTime.now(),
    );

    when(mockBox.getAt(0)).thenReturn(note);
    when(mockBox.putAt(0, note)).thenAnswer((_) async {});

    noteData.updateNote(0, 'Updated Title', 'Updated Body', 'high');

    verify(mockBox.putAt(0, note)).called(1);
    expect(note.title, 'Updated Title');
    expect(note.body, 'Updated Body');
    expect(note.priority, 'high');
  });

  test('Sort notes by title', () {
    final note1 = Note(
      id: 1,
      title: 'B Note',
      body: 'This is a test',
      priority: 'low',
      created: DateTime.now(),
    );
    final note2 = Note(
      id: 2,
      title: 'A Note',
      body: 'Another test',
      priority: 'high',
      created: DateTime.now(),
    );

    when(mockBox.values).thenReturn([note1, note2]);

    noteData.sortNotes('title', true);

    expect(noteData.filteredNotes[0].title, 'A Note');
    expect(noteData.filteredNotes[1].title, 'B Note');
  });
}
