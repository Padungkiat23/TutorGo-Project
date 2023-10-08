import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tutorgo/pages/widget/header_widget.dart';

class PostCourseInfoPage extends StatelessWidget {
  final Map<String, dynamic> postCourseData;

  const PostCourseInfoPage({required this.postCourseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Information',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).hintColor,
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            child: HeaderWidget(75, false, Icons.house_rounded),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Course Name: ${postCourseData['courseName']}'),
                Text('Price: ${postCourseData['price']}'),
                Text('Address: ${postCourseData['address']}'),
                Text('Contact Info: ${postCourseData['contactInfo']}'),
                // Assuming imageUrl is a link to the image
                Image.network(postCourseData['imageUrl'] ?? ''),
                // Assuming googleMapsLink is a link to Google Maps
                TextButton(
                  onPressed: () {
                    // Open the Google Maps link
                    launch(postCourseData['googleMapsLink']);
                  },
                  child: Text('Open in Google Maps'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
