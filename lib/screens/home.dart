// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:testt/main.dart';
import 'package:testt/screens/bakaloria.dart';
import 'package:testt/screens/profile.dart';
import 'package:testt/screens/login.dart';
import 'package:testt/screens/register.dart';
import 'package:testt/screens/tase3.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import CurvedNavigationBar
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'videoPost.dart';

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
                    icon: Icon(Icons.logout, size: 20.h),
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

  Future<bool> isAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    return username == 'kminchelle';
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return SingleChildScrollView(
        child: Padding(
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
                const Divider(),
                FutureBuilder<bool>(
                  future: isAdmin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data == true) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                " تسجيل الأساتذة والطلاب",
                                style: TextStyle(fontSize: 25.sp),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.to(const RegisterScreen());
                            },
                            child: Text(
                              'التسجيل',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "تحميل دروس",
                                style: TextStyle(fontSize: 25.sp),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(VideoPost());
                            },
                            child: Text(
                              'التحميل',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_selectedIndex == 1) {
      return Container(
        height: 600.h,
        child: FutureBuilder<UserInfo>(
          future: getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final userInfo = snapshot.data;
              final email, _firstName, _lastName, _gender;
              email = userInfo?.email; // Update the state variable with email
              _firstName = userInfo
                  ?.firstName; // Update the state variable with firstName
              _lastName =
                  userInfo?.lastName; // Update the state variable with lastName
              _gender =
                  userInfo?.gender; // Update the state variable with gender
              return Profile(
                email: email,
                firstName: _firstName,
                lastName: _lastName,
                gender: _gender,
                username: '',
              ); // Return your widget
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Future<UserInfo> getUserInfo() async {
    final email = prefs?.getString('email') ?? '';
    final firstName = prefs?.getString('firstName') ?? '';
    final lastName = prefs?.getString('lastName') ?? '';
    final gender = prefs?.getString('gender') ?? '';
    return UserInfo(
        email: email, firstName: firstName, lastName: lastName, gender: gender);
  }

  Future<String> getUsername() async {
    return prefs?.getString('username') ?? '';
  }

  Future<void> _logout(BuildContext context) async {
    await prefs?.clear();
    Get.off(SignInScreen());
  }
}

class UserInfo {
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  UserInfo(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.gender});
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

  HorizontalList({super.key});
  @override
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
