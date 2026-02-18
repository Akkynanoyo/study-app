import 'package:flutter/material.dart';

class Schedule {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String userId;
  final DateTime createdAt;

  Schedule({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': '${time.hour}:${time.minute}',
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map, String id) {
    final timeParts = (map['time'] as String).split(':');
    return Schedule(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as dynamic).toDate(),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }
}
