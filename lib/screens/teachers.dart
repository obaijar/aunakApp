// ignore_for_file: depend_on_referenced_packages, camel_case_types, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:testt/screens/Courses.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class teachers extends StatefulWidget {
  final String subject;
  final int grade;
  teachers({required this.subject, required this.grade});
  @override
  State<teachers> createState() => _teachersState();
}

class _teachersState extends State<teachers> {
  List jsonList = [];
  bool isLoading = false;
  String subject2 = " ";
  int gradeIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.subject == "عربي") subject2 = "arabic";
    if (widget.subject == "إجتماعيات") subject2 = "Social Studies";
    if (widget.subject == "فلسفة") subject2 = "Philosophy";
    if (widget.subject == "رياضيات") subject2 = "math";
    if (widget.subject == "فيزياء") subject2 = "physics";
    getData();
    if (widget.grade == 9) gradeIndex = 1;
    if (widget.grade == 12) gradeIndex = 2;
    if (widget.grade == 13) gradeIndex = 3;
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;
      if (!isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يوجد اتصال بالإنترنت. يرجى المحاولة مرة أخرى'),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return; // Exit the button press function if no connection
      }

      var response = await Dio().get(
        "http://10.0.2.2:8000/api/teachers/${widget.grade}/${widget.subject}",
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data as List;
          isLoading = false;
        });
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemClicked(int index) {
    Get.to(() => Courses(
          teacher: jsonList[index]['id'],
          subject: widget.subject,
          section: widget.grade,
        ));
    // Handle item click here, you can navigate to a new page, show a dialog, etc.
    print("Item clicked: ${jsonList[index]['id']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "اختر إستاذك",
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                if (!isLoading && jsonList.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: jsonList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _onItemClicked(index),
                          child: Card(
                            elevation: 3.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage(
                                    "images/111.png"), // Use AssetImage('path/to/image.png') for local images
                                radius: 20.0, // Adjust the radius as needed
                              ),
                              title: Text(
                                jsonList[index]['name'],
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                              ),
                              subtitle: Text(
                                "مادة: ${widget.subject}",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
