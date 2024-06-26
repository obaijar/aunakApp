// ignore_for_file: depend_on_referenced_packages, use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/teachers.dart';
import 'package:get/get.dart';

class GridItem {
  final String imageUrl;
  final String text;

  GridItem({required this.imageUrl, required this.text});
}

class Tase3 extends StatefulWidget {
  const Tase3({Key? key}) : super(key: key);

  @override
  State<Tase3> createState() => _Tase3State();
}

class _Tase3State extends State<Tase3> {
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
                              section: 1,
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


// ------------------------------------------------------
/*
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Tase3 extends StatefulWidget {
  const Tase3({super.key});

  @override
  State<Tase3> createState() => _Tase3State();
}

class _Tase3State extends State<Tase3> {
  List jsonList = [];
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      isLoading = true; // Start loading indicator
    });
    try {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تاسع"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(jsonList[index]['name']),
                      subtitle: (const Text("test")),
                    ),
                  ),
                ],
              );
            },
            // ignore: unnecessary_null_comparison
            itemCount: jsonList == null ? 0 : jsonList.length,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(), // Loading indicator
            ),
        ],
      ),
    );
  }
}
*/
