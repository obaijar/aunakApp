import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridItem {
  final String imageUrl;
  final String text;

  GridItem({required this.imageUrl, required this.text});
}

class bakaloriaAdabi extends StatefulWidget {
  const bakaloriaAdabi({super.key});

  @override
  State<bakaloriaAdabi> createState() => _bakaloriaAdabiState();
}

class _bakaloriaAdabiState extends State<bakaloriaAdabi> {
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
          return Center(
            child: GestureDetector(
              onTap: () {
                // Handle click event here, for example, navigate to a new page
                print('Image clicked: ${gridItems[index].text}');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    gridItems[index].imageUrl,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10), // Spacer between image and text
                  Text(
                    gridItems[index].text,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
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
          return Center(
            child: GestureDetector(
              onTap: () {
                // Handle click event here, for example, navigate to a new page
                print('Image clicked: ${gridItems[index].text}');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    gridItems[index].imageUrl,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10), // Spacer between image and text
                  Text(
                    gridItems[index].text,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
