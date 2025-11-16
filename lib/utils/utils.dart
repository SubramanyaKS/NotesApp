import 'package:flutter/material.dart';
import 'package:notesapp/utils/priority.dart';

Color getPriorityColor(priority) {
  Color color = Colors.green;
  if (priority == Priority.high.name) {
    color = Colors.red;
  }
  if (priority == Priority.medium.name) {
    color = Colors.yellow;
  }
  return color;
}

Priority? priorityFromString(String priorityString) {
  try {
    return Priority.values.byName(priorityString);
  } catch (e) {
    return null; // Handle invalid strings gracefully
  }
}

Map<String, String> sortOptions = {
  'Title Asc': 'Sort by Title Asc',
  'Title Desc': 'Sort by Title Desc',
  'Index Asc': 'Sort by Index Asc',
  'Index Desc': 'Sort by Index Desc'
};
