import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testt/screens/teachers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GridItem {
  final String imageUrl;
  final String text;

  GridItem({required this.imageUrl, required this.text});
}

// ignore: camel_case_types
class bakaloriaAdabi extends StatefulWidget {
  const bakaloriaAdabi({super.key});

  @override
  State<bakaloriaAdabi> createState() => _bakaloriaAdabiState();
}

// ignore: camel_case_types
class _bakaloriaAdabiState extends State<bakaloriaAdabi> {
  List<GridItem> gridItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    const grade = 3; // Use the correct grade as needed
    final url = Uri.parse('http://10.0.2.2:8000/api/Subject/$grade/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List subjects = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        gridItems = subjects
            .map((subject) => GridItem(
                  imageUrl: 'images/img8.png', // Use appropriate image URL
                  text: subject[
                      'name'], // Adjust according to your API response structure
                ))
            .toList();
        isLoading = false;
      });
    } else {
      print('Failed to load subjects');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المواد",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              children: List.generate(gridItems.length, (index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.w), // Add padding here
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.black45,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => teachers(
                                    subject: gridItems[index].text,
                                    grade: 13,
                                  ));
                              print('Image clicked: ${gridItems[index].text}');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  gridItems[index].imageUrl,
                                  height: 80.h,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          gridItems[index].text,
                                          style: TextStyle(fontSize: 20.sp),
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          maxLines: 1, // Limit to 1 line
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Image.asset(
                                        width: 40.w,
                                        height: 40.h,
                                        "images/111.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
    );
  }
}

// ignore: camel_case_types
class bakaloria3lmi extends StatefulWidget {
  const bakaloria3lmi({super.key});

  @override
  State<bakaloria3lmi> createState() => _bakaloria3lmiState();
}

// ignore: camel_case_types
class _bakaloria3lmiState extends State<bakaloria3lmi> {
  List<GridItem> gridItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    const grade = 2; // Use the correct grade as needed
    final url = Uri.parse('http://10.0.2.2:8000/api/Subject/$grade/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List subjects = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        gridItems = subjects
            .map((subject) => GridItem(
                  imageUrl: 'images/img8.png', // Use appropriate image URL
                  text: subject[
                      'name'], // Adjust according to your API response structure
                ))
            .toList();
        isLoading = false;
      });
    } else {
      print('Failed to load subjects');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المواد",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2, // Number of columns in the grid
              children: List.generate(gridItems.length, (index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.w), // Add padding here
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.black45,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => teachers(
                                    subject: gridItems[index].text,
                                    grade: 12,
                                  ));
                              print('Image clicked: ${gridItems[index].text}');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  gridItems[index].imageUrl,
                                  height: 80.h,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          gridItems[index].text,
                                          style: TextStyle(fontSize: 20.sp),
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          maxLines: 1, // Limit to 1 line
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Image.asset(
                                        "images/111.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
    );
  }
}
