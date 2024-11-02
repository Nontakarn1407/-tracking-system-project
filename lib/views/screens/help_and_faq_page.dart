import 'package:flutter/material.dart';

class HelpAndFAQPage extends StatelessWidget {
  const HelpAndFAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'คำถามที่พบบ่อยเกี่ยวกับพนักงานเคลม',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  _faqItem(
                    question: 'พนักงานเคลมต้องมีคุณสมบัติอะไรบ้าง?',
                    answer: 'พนักงานเคลมควรมีความรู้เกี่ยวกับกฎหมายประกันภัย, กระบวนการเคลม, และทักษะการสื่อสารที่ดี.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมควรรู้เกี่ยวกับเอกสารอะไรบ้าง?',
                    answer: 'พนักงานเคลมควรรู้จักเอกสารที่เกี่ยวข้อง เช่น ใบแจ้งเคลม, รายงานการตรวจสอบ, และเอกสารประกันภัย.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมควรทำอย่างไรเมื่อพบปัญหา?',
                    answer: 'หากพบปัญหา พนักงานเคลมควรติดต่อหัวหน้าหรือผู้จัดการทันทีเพื่อขอคำแนะนำ.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมควรเก็บข้อมูลอย่างไร?',
                    answer: 'พนักงานเคลมควรเก็บข้อมูลทั้งหมดเกี่ยวกับการเคลมในระบบฐานข้อมูล เพื่อให้สามารถติดตามได้ง่าย.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมควรทำงานร่วมกับใคร?',
                    answer: 'พนักงานเคลมควรทำงานร่วมกับทีมซ่อมแซม, ทีมการตลาด, และฝ่ายบริการลูกค้าเพื่อให้การเคลมเป็นไปอย่างราบรื่น.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมควรมีทักษะอะไรในการทำงาน?',
                    answer: 'พนักงานเคลมควรมีทักษะการสื่อสารที่ดี, การวิเคราะห์, การแก้ปัญหา, และการบริหารจัดการเวลา.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมต้องรับผิดชอบเรื่องใดบ้าง?',
                    answer: 'พนักงานเคลมต้องรับผิดชอบในการตรวจสอบเคลม, ประเมินค่าใช้จ่าย, และให้ข้อมูลที่ถูกต้องแก่ลูกค้า.',
                  ),
                  _faqItem(
                    question: 'พนักงานเคลมควรได้รับการฝึกอบรมอย่างไร?',
                    answer: 'พนักงานเคลมควรได้รับการฝึกอบรมเกี่ยวกับกระบวนการเคลม, การใช้ระบบสารสนเทศ, และการบริการลูกค้า.',
                  ),
                  _faqItem(
                    question: 'สิ่งที่พนักงานเคลมควรทำเมื่อได้รับการร้องเรียน?',
                    answer: 'พนักงานเคลมควรฟังลูกค้าอย่างตั้งใจ, รับข้อร้องเรียน, และพยายามหาทางแก้ไขหรือให้คำแนะนำที่เหมาะสม.',
                  ),
                  // เพิ่มคำถามอื่น ๆ ที่ต้องการที่นี่
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _faqItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(question),
      children: [Padding(padding: const EdgeInsets.all(8.0), child: Text(answer))],
    );
  }
}
