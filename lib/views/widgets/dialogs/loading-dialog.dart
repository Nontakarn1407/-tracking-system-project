// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // ทำให้มุมของ Dialog โค้ง
      ),
      child: Padding(
        padding: const EdgeInsets.all(16), // เพิ่ม padding เพื่อให้มีระยะห่าง
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: LoadingAnimationWidget.waveDots(
                color: Colors.black38,
                size: 60,
              ),
            ),
            const SizedBox(height: 16), // เพิ่มระยะห่างระหว่างแอนิเมชันกับข้อความ
            const Text(
              'กำลังโหลด...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
