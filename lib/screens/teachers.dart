// ignore_for_file: depend_on_referenced_packages, camel_case_types, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:testt/screens/Courses.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class teachers extends StatefulWidget {
  final String subject;
  final int section;
  teachers({required this.subject, required this.section});
  @override
  State<teachers> createState() => _teachersState();
}

class _teachersState extends State<teachers> {
  List jsonList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected =
          connectivityResult.any((result) => result != ConnectivityResult.none);
      if (!isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يوجد اتصال بالإنترنت. يرجى المحاولة مرة أخرى'),
          ),
        );
        return; // Exit the button press function if no connection
      }
      var response = await Dio()
          .get("https://protocoderspoint.com/jsondata/superheros.json");
      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data["superheros"] as List;
          isLoading = false;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void _onItemClicked(int index) {
    Get.to(() => Courses(
          teacher: jsonList[index]['name'],
          subject: widget.subject,
          section: widget.section,
        ));
    // Handle item click here, you can navigate to a new page, show a dialog, etc.
    print("Item clicked: ${jsonList[index]['name']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الأساتذة",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
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
