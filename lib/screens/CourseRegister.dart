import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/screens/RegisterConformation.dart';

class CourseRegister extends StatefulWidget {
  final String courseName;
  final int courseID;
  final int teacher;
  final String subject;
  final int section;

  const CourseRegister({
    super.key,
    required this.courseName,
    required this.courseID,
    required this.teacher,
    required this.subject,
    required this.section,
  });

  @override
  _CourseRegisterState createState() => _CourseRegisterState();
}

class _CourseRegisterState extends State<CourseRegister> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> performRegistration() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get token and user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId = prefs.getString('id');

      if (userId == null) {
        print('User ID not found in SharedPreferences');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Define the GET request URL
      final String getUrl =
          'https://obai.aunakit-hosting.com/api/courses/search/1/${widget.subject}/1/1/';

      // Perform the GET request to get the course ID
      dio.Response getResponse = await dio.Dio().get(
        getUrl,
        options: dio.Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );
      print(getResponse.data);
      if (getResponse.statusCode == 200 && getResponse.data.isNotEmpty) {
        int courseId = getResponse.data[0]
            ['id']; // Assuming the first course is the relevant one

        // Define the POST request URL
        const String postUrl =
            'https://obai.aunakit-hosting.com/api/purchases/';

        // Perform the POST request to register the purchase
        dio.Response postResponse = await dio.Dio().post(
          postUrl,
          data: {
            'user': userId,
            'course': courseId,
          },
          options: dio.Options(
            headers: {
              'Authorization': 'Token $token',
            },
          ),
        );

        if (postResponse.statusCode == 201) {
          // Navigate to the confirmation page
          print("ook doneeeeeeeeeeeee");
          //Get.to(() => RegisterConformation());
        } else {
          // Handle POST request failure
          print('Failed to register purchase');
        }
      } else {
        // Handle GET request failure or empty response
        print('Failed to retrieve course');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
        'الدفع',
        style: TextStyle(
          fontSize: 18.sp, // Set the font size you want here
        ),
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "سيرياتيل كاش",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Material(
                  elevation: 4.0, // Adjust the elevation value as needed
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'إسم المستخدم',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم المستخدم';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Material(
                  elevation: 4.0, // Adjust the elevation value as needed
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'الإيميل',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال الإيميل';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Material(
                  elevation: 4.0, // Adjust the elevation value as needed
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextFormField(
                    controller: phonenumberController,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(height: 20.h),
                isLoading
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await performRegistration();
                          }
                        },
                        child: Text(
                          'الدفع',
                          style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
