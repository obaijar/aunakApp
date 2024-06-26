import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/CourseVideos.dart';
import 'package:get/get.dart';

//
class RegisterConformation extends StatefulWidget {
  const RegisterConformation({super.key});

  @override
  State<RegisterConformation> createState() => _RegisterConformationState();
}

class _RegisterConformationState extends State<RegisterConformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Image.asset("images/131.png"),
            SizedBox(
              height: 10.h,
            ),
            Text("السعر",
                style: TextStyle(
                  fontSize: 20.sp,
                )),
            Text("تمت عملية الدفع بنجاح",
                style: TextStyle(
                  fontSize: 14.sp,
                )),
            Text(
              "عملية الدفع تمت في :",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
            Text("Transaction ID :",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                )),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: InkWell(
                onTap: () {
                  Get.to(const CourseVideo());
                },
                child: Ink.image(image: const AssetImage("images/141.png")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
