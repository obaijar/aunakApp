import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testt/screens/teachers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<GridItem> gridItems = [];

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    const grade = 1; // Use the correct grade as needed
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://obai.aunakit-hosting.com/api/Subject/$grade/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token', // Replace with your token
      },
    );

    if (response.statusCode == 200) {
      final List subjects = json.decode(response.body);
      setState(() {
        gridItems = subjects
            .map((subject) => GridItem(
                  imageUrl: 'images/img8.png', // Use appropriate image URL
                  text: subject[
                      'name'], // Adjust according to your API response structure
                ))
            .toList();
      });
    } else {
      print('Failed to load subjects');
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
                              grade: 9,
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
                                style: TextStyle(fontSize: 18.sp),
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
