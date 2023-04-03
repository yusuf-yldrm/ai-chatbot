import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String profileImage;
  final List<String> pastImages;

  const ProfileScreen({
    required this.userName,
    required this.profileImage,
    required this.pastImages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  radius: 50.0,
                ),
                SizedBox(height: 16.0),
                Text(userName, style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pastImages.length,
              itemBuilder: (context, index) {
                final image = pastImages[index];

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Image.network(image),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
