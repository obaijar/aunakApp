// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:testt/main.dart';
import 'package:testt/screens/bakaloria.dart';
import 'package:testt/screens/profile.dart';
import 'package:testt/screens/login.dart';
import 'package:testt/screens/tase3.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import CurvedNavigationBar
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String? _id; // Declare a state variable to hold the ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'برنامج تعليمي',
              style: TextStyle(fontSize: 20.sp),
            ),
            const Spacer(), // Add spacer to push the username to the right
            FutureBuilder<String>(
              future: getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String? username = snapshot.data;
                  if (username!.isNotEmpty) {
                    return Text(
                      'أهلا, $username',
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    );
                  } else {
                    return Text(
                      'أهلا زائر',
                      style: TextStyle(fontSize: 20.sp),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          FutureBuilder<String>(
            future: getUsername(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Return an empty container while retrieving data
              } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Check if username is not null or empty
                  return IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      _logout(
                          context); // Call logout function when the button is pressed
                    },
                  );
                } else {
                  return Container(); // Return an empty container if user is not logged in
                }
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: const [
          Icon(Icons.home),
          Icon(Icons.person),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return Padding(
        padding: EdgeInsets.all(8.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "الأقسام",
                    style: TextStyle(fontSize: 25.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              HorizontalList(),
            ],
          ),
        ),
      );
    } else if (_selectedIndex == 1) {
      return FutureBuilder<String>(
        future: getId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            _id = snapshot.data; // Update the state variable
            return Profile(id: _id);
          }
        },
      );
    } else {
      return Container();
    }
  }

  Future<String> getId() async {
    return prefs?.getString('id') ?? '';
  }

  Future<String> getUsername() async {
    return prefs?.getString('username') ?? '';
  }

  Future<void> _logout(BuildContext context) async {
    await prefs?.clear();
    Get.off(SignInScreen());
  }
}

class HorizontalList extends StatelessWidget {
  final List<String> items = [
    'تاسع',
    'بكالوريا أدبي',
    'بكالوريا علمي',
  ];
  final List<String> imageUrls = [
    'images/image5.png', // Sample image URL 1
    'images/image6.png', // Sample image URL 2
    'images/image7.png', // Sample image URL 3
  ];
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle tap here
                  if (index == 0) {
                    Get.to(() => const Tase3());
                  }
                  if (index == 1) {
                    Get.to(() => const bakaloriaAdabi());
                  }
                  if (index == 2) {
                    Get.to(() => const bakaloria3lmi());
                  }
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 75.h,
                      child: Image.asset(
                        imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      items[index],
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40.h,
              )
            ],
          );
        },
      ),
    );
  }
}
