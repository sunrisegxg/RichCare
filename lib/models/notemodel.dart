import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlannerNote {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final TimeOfDay? reminder;

  PlannerNote({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'reminderHour': reminder?.hour,
      'reminderMinute': reminder?.minute,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory PlannerNote.fromMap(String id, Map<String, dynamic> map) {
    return PlannerNote(
      id: id,
      title: map['title'],
      description: map['description'],
      date: (map['date'] as Timestamp).toDate(),
      reminder: map['reminderHour'] != null
          ? TimeOfDay(hour: map['reminderHour'], minute: map['reminderMinute'])
          : null,
    );
  }
}
