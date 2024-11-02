import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ฟังก์ชันบันทึกเหตุการณ์
  Future<void> addEvent(DateTime date, String event) async {
    try {
      // ตรวจสอบว่ามีเหตุการณ์นี้อยู่แล้วหรือไม่
      bool eventExists = await isEventExists(date, event);
      if (!eventExists) {
        DateTime onlyDate = DateTime(date.year, date.month, date.day);
        await _db.collection('events').add({
          'date': Timestamp.fromDate(onlyDate), // แปลง DateTime เป็น Timestamp
          'event': event,
        });
      } else {
        print('Event already exists.');
      }
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  // ฟังก์ชันโหลดเหตุการณ์จาก Firestore
  Future<Map<DateTime, List<String>>> loadEvents() async {
    Map<DateTime, List<String>> eventMap = {};
    try {
      QuerySnapshot snapshot = await _db.collection('events').get();
      for (var doc in snapshot.docs) {
        DateTime eventDate = (doc['date'] as Timestamp).toDate();
        String eventName = doc['event'];
        DateTime onlyDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // ใช้เฉพาะวันที่
        eventMap.putIfAbsent(onlyDate, () => []).add(eventName); // ใช้ putIfAbsent เพื่อให้โค้ดกระชับขึ้น
      }
    } catch (e) {
      print('Error loading events: $e');
    }
    return eventMap;
  }

  // ฟังก์ชันโหลดเหตุการณ์เฉพาะช่วงวัน
  Future<Map<DateTime, List<String>>> loadEventsByDateRange(DateTime startDate, DateTime endDate) async {
    Map<DateTime, List<String>> eventMap = {};
    try {
      DateTime onlyStartDate = DateTime(startDate.year, startDate.month, startDate.day);
      DateTime onlyEndDate = DateTime(endDate.year, endDate.month, endDate.day);

      QuerySnapshot snapshot = await _db.collection('events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(onlyStartDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(onlyEndDate))
          .get();

      for (var doc in snapshot.docs) {
        DateTime eventDate = (doc['date'] as Timestamp).toDate();
        String eventName = doc['event'];
        DateTime onlyDate = DateTime(eventDate.year, eventDate.month, eventDate.day);

        eventMap.putIfAbsent(onlyDate, () => []).add(eventName); // ใช้ putIfAbsent เพื่อให้โค้ดกระชับขึ้น
      }
    } catch (e) {
      print('Error loading events by date range: $e');
    }
    return eventMap;
  }

  // ฟังก์ชันแก้ไขเหตุการณ์
  Future<void> updateEvent(DateTime oldDate, String oldEvent, DateTime newDate, String newEvent) async {
    try {
      DateTime onlyOldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
      DateTime onlyNewDate = DateTime(newDate.year, newDate.month, newDate.day);

      // ค้นหาเหตุการณ์ที่ต้องการแก้ไข
      QuerySnapshot snapshot = await _db.collection('events')
          .where('date', isEqualTo: Timestamp.fromDate(onlyOldDate))
          .where('event', isEqualTo: oldEvent)
          .get();

      for (var doc in snapshot.docs) {
        // แก้ไขข้อมูล
        await doc.reference.update({
          'date': Timestamp.fromDate(onlyNewDate), // อัปเดตวันที่
          'event': newEvent, // อัปเดตเหตุการณ์
        });
      }
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  // ฟังก์ชันลบเหตุการณ์
  Future<void> removeEvent(DateTime date, String event) async {
    try {
      DateTime onlyDate = DateTime(date.year, date.month, date.day); // ใช้เฉพาะวันที่
      QuerySnapshot snapshot = await _db.collection('events')
          .where('date', isEqualTo: Timestamp.fromDate(onlyDate)) // เปรียบเทียบด้วยเฉพาะวันที่
          .where('event', isEqualTo: event)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete(); // ลบเอกสาร
      }
    } catch (e) {
      print('Error removing event: $e');
    }
  }

  // ฟังก์ชันตรวจสอบว่าเหตุการณ์มีอยู่แล้วหรือไม่
  Future<bool> isEventExists(DateTime date, String event) async {
    try {
      DateTime onlyDate = DateTime(date.year, date.month, date.day);

      QuerySnapshot snapshot = await _db.collection('events')
          .where('date', isEqualTo: Timestamp.fromDate(onlyDate))
          .where('event', isEqualTo: event)
          .get();

      return snapshot.docs.isNotEmpty; // ถ้าเอกสารไม่ว่างแสดงว่ามีเหตุการณ์นี้แล้ว
    } catch (e) {
      print('Error checking event existence: $e');
      return false;
    }
  }
}
