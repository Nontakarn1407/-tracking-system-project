import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DateTime date;
  final String name;

  Event({required this.date, required this.name});

  // แปลงจากคลาส Event ไปเป็น Map
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date), // แปลง DateTime เป็น Timestamp
      'event': name,
    };
  }

  // แปลงจาก Map ไปเป็นคลาส Event
  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      date: (map['date'] as Timestamp).toDate(), // แปลง Timestamp เป็น DateTime
      name: map['event'],
    );
  }
}
