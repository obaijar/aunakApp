import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/DeleteVideo.dart';
import 'package:testt/screens/videoPost.dart';

class DrosPage extends StatelessWidget {
  const DrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدروس'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'تحميل درس',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const VideoPost());
                    // Action for Button 1
                  },
                  child: Text(
                    'التحميل',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16.0), // Spacing between elements
            // Third Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'حذف درس',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const DeleteVideo());
                  },
                  child: Text(
                    'الحذف',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
