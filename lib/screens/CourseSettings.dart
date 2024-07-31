// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:testt/screens/AddCourse.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseSettings extends StatelessWidget {
  const CourseSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كورس'),
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
                    'إضافة كورس',
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
                    Get.to(() => const AddCourse());
                    // Action for Button 1
                  },
                  child: Text(
                    'إضافة',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16.0), // Spacing between elements

            // Second Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'تعديل كورس',
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
                    // Action for Button 2
                  },
                  child: Text(
                    'تعديل',
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
                    'حذف كورس',
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
                    // Action for Button 3
                  },
                  child: Text(
                    'حذف',
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
