import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // เพิ่มการนำเข้า
import 'package:provider/provider.dart';

// คลาส FirestoreService
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addEvent(DateTime date, String event) async {
    try {
      await _db.collection('events').add({
        'date': Timestamp.fromDate(date), // Store as Timestamp
        'event': event,
      });
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  // ฟังก์ชันเพื่อโหลดเหตุการณ์จาก Firestore
  Future<Map<DateTime, List<String>>> loadEvents() async {
    Map<DateTime, List<String>> eventMap = {};
    try {
      QuerySnapshot snapshot = await _db.collection('events').get();
      for (var doc in snapshot.docs) {
        DateTime eventDate = (doc['date'] as Timestamp).toDate();
        String eventName = doc['event'];
        DateTime onlyDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
        eventMap[onlyDate] = (eventMap[onlyDate] ?? [])..add(eventName);
      }
    } catch (e) {
      print('Error loading events: $e');
    }
    return eventMap;
  }

  // เพิ่มเมธอดเพื่อให้สามารถลบเหตุการณ์ได้
  Future<void> removeEvent(DateTime date, String event) async {
    try {
      QuerySnapshot snapshot = await _db.collection('events')
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('event', isEqualTo: event)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete(); // ลบเอกสาร
      }
    } catch (e) {
      print('Error removing event: $e');
    }
  }
}

class EventCalendarPage extends StatefulWidget {
  const EventCalendarPage({super.key});

  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  late Map<DateTime, List<String>> events;
  late List<String> selectedEvents;
  late DateTime selectedDay;

  final Color customColor = const Color.fromARGB(255, 71, 124, 168);
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    events = {};
    selectedEvents = [];
    _loadEvents(); // เรียกฟังก์ชันโหลดเหตุการณ์ที่นี่
  }

  Future<void> _loadEvents() async {
    try {
      events = await _firestoreService.loadEvents();
      setState(() {
        selectedEvents = events[selectedDay] ?? [];
      });
    } catch (e) {
      print('Error loading events: $e'); // แสดงข้อผิดพลาดใน console
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
      selectedEvents = events[day] ?? [];
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy – h:mm a').format(date); // จัดรูปแบบวันที่
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController eventController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Event'),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(hintText: 'Event Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String eventText = eventController.text.trim();
                if (eventText.isNotEmpty && !selectedEvents.contains(eventText)) {
                  setState(() {
                    // เพิ่มเหตุการณ์ใน UI
                    events[selectedDay] = (events[selectedDay] ?? [])..add(eventText);
                    selectedEvents = events[selectedDay]!;

                    // เพิ่มเหตุการณ์ลง Firestore
                    _firestoreService.addEvent(selectedDay, eventText);
                  });
                  Navigator.of(context).pop(); // ปิด Dialog
                } else if (selectedEvents.contains(eventText)) {
                  // แสดงข้อผิดพลาดหากเหตุการณ์มีอยู่แล้ว
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event already exists!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeEvent(int index) {
    String eventToRemove = selectedEvents[index];
    setState(() {
      selectedEvents.removeAt(index);
      if (selectedEvents.isEmpty) {
        events.remove(selectedDay);
      }
      _firestoreService.removeEvent(selectedDay, eventToRemove);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$eventToRemove removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Calendar',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : customColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            focusedDay: selectedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) => events[day] ?? [],
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: customColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: selectedEvents.isNotEmpty
                ? ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(selectedEvents[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeEvent(index),
                        ),
                      );
                    },
                  )
                : Center(child: Text('No events found for this date')), // แสดงข้อความเมื่อไม่มีเหตุการณ์
          ),
        ],
      ),
    );
  }
}
