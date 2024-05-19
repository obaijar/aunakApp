import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:testt/screens/Courses.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Adabiteachers extends StatefulWidget {
  final String subject;
  Adabiteachers({required this.subject});
  @override
  State<Adabiteachers> createState() => _AdabiteachersState();
}

class _AdabiteachersState extends State<Adabiteachers> {
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
                              title: Text(jsonList[index]['name']),
                              subtitle: Text("مادة: ${widget.subject}"),
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
