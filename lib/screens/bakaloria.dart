// ignore_for_file: depend_on_referenced_packages, camel_case_types, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testt/screens/teachers.dart';

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
  List<GridItem> gridItems = [
    GridItem(
      imageUrl: 'images/img8.png',
      text: 'فلسفة',
    ),
    GridItem(
      imageUrl: 'images/img8.png',
      text: 'عربي',
    ),
    GridItem(
      imageUrl: 'images/img8.png',
      text: 'إجتماعيات',
    ),
    // Add more items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المواد",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: GridView.count(
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
                              section: 3,
                            ));
                        // Handle click event here, for example, navigate to a new page
                        print('Image clicked: ${gridItems[index].text}');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            gridItems[index].imageUrl,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ), // Spacer between image and text
                          Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                              ),
                              Text(
                                gridItems[index].text,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              Image.asset(
                                width: 40.w,
                                height: 40.h,
                                "images/111.png",
                                fit: BoxFit.cover,
                              ),
                            ],
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

class bakaloria3lmi extends StatefulWidget {
  const bakaloria3lmi({super.key});

  @override
  State<bakaloria3lmi> createState() => _bakaloria3lmiState();
}

class _bakaloria3lmiState extends State<bakaloria3lmi> {
  List<GridItem> gridItems = [
    GridItem(
      imageUrl: 'images/img8.png',
      text: 'رياضيات',
    ),
    GridItem(
      imageUrl: 'images/img8.png',
      text: 'عربي',
    ),
    GridItem(
      imageUrl: 'images/img8.png',
      text: 'فيزياء',
    ),
    // Add more items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المواد",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: GridView.count(
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
                              section: 2,
                            ));
                        // Handle click event here, for example, navigate to a new page
                        print('Image clicked: ${gridItems[index].text}');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            gridItems[index].imageUrl,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ), // Spacer between image and text
                          Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                              ),
                              Text(
                                gridItems[index].text,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              Image.asset(
                                "images/111.png",
                                fit: BoxFit.cover,
                              ),
                            ],
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
