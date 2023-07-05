import 'package:flutter/material.dart';

Widget buildAboutSection() {
  return Center(
    child: Text('About Section'),
  );
}

Widget buildTeamsSection() {
  return Center(
    child: Text('Teams Section'),
  );
}

Widget buildAlbumSection() {
  return Center(
    child: Text('Album Section'),
  );
}

Widget buildCoverPhoto(double coverHeight) {
  return Container(
    width: double.infinity,
    height: coverHeight,
    decoration: BoxDecoration(
      color: Colors.blue,
      image: DecorationImage(
        image: AssetImage('Slider1.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildProfilePhoto(double profileHeight) {
  return CircleAvatar(
    radius: profileHeight / 2,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        image: DecorationImage(
          image: AssetImage('Slider2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget buildTagWithIcon(BuildContext context, String tag, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.blue,
        size: 16,
      ),
      SizedBox(width: 5),
      Text(
        tag,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget buildTextWithPadding(
    String text, double fontSize, FontWeight fontWeight) {
  return Padding(
    padding: EdgeInsets.only(left: 10),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}
