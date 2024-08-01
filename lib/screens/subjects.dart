// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Subjects extends StatelessWidget {
  const Subjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المواد'),
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
                    'إضافة مادة',
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
                    Get.to(() => const AddSubject());
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
            // Third Text and Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'حذف مادة',
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
                    Get.to(() => const DeleteSubject());
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

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DeleteSubject extends StatefulWidget {
  const DeleteSubject({super.key});

  @override
  State<DeleteSubject> createState() => _DeleteSubjectState();
}

class _DeleteSubjectState extends State<DeleteSubject> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
