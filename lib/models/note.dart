import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String body;
  @HiveField(3)
  DateTime created;

  Note({required this.id,required this.title,required this.body,required this.created});

}