import 'package:cloud_firestore/cloud_firestore.dart';

class SOSModel {
  String? id; // ID ของเอกสารใน Firestore (อาจเป็น null ถ้ายังไม่ได้สร้าง)
  String userId; // ID ของผู้ใช้
  GeoPoint location; // ตำแหน่ง (ใช้ GeoPoint สำหรับ Firebase)
  DateTime timestamp; // เวลาที่เกิดเหตุ

  SOSModel({
    this.id, // id เป็นตัวเลือก (nullable) เพราะยังไม่มีเมื่อบันทึกใหม่
    required this.userId,
    required this.location,
    required this.timestamp,
  });

  // ฟังก์ชันสำหรับแปลงข้อมูลเป็น Map เพื่อบันทึกใน Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'location': location,
      'timestamp': Timestamp.fromDate(timestamp), // บันทึกเป็น Timestamp
    };
  }

  // ฟังก์ชันสำหรับสร้าง SOSModel จาก Map (เมื่อดึงข้อมูลจาก Firestore)
  factory SOSModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SOSModel(
      id: documentId, // ใช้ documentId จาก Firestore
      userId: map['userId'] ?? '',
      location: map['location'] as GeoPoint, // รับ GeoPoint จาก Firestore
      timestamp: (map['timestamp'] as Timestamp).toDate(), // แปลง Timestamp เป็น DateTime
    );
  }

  // ฟังก์ชันสำหรับตรวจสอบความถูกต้องของข้อมูล
  bool isValid() {
    return userId.isNotEmpty && location != null && timestamp != null;
  }

  // ฟังก์ชันแสดงผลข้อมูล
  @override
  String toString() {
    return 'SOSModel{id: $id, userId: $userId, location: $location, timestamp: $timestamp}';
  }

  // ฟังก์ชันบันทึกข้อมูลลง Firestore
  Future<void> saveToFirestore() async {
    if (isValid()) {
      final DocumentReference docRef = FirebaseFirestore.instance.collection('sos_messages').doc(id);
      await docRef.set(toMap()); // ใช้ set() เพื่อบันทึกข้อมูล
    } else {
      throw Exception('Invalid SOSModel data');
    }
  }

  // ฟังก์ชันเปรียบเทียบ
  bool equals(SOSModel other) {
    return userId == other.userId && 
           location.latitude == other.location.latitude &&
           location.longitude == other.location.longitude &&
           timestamp == other.timestamp;
  }
}
