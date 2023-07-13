import 'dart:async';

import 'package:captsone_ui/services/team.dart';
import 'package:flutter/material.dart';
import 'package:captsone_ui/services/auth_provider.dart';
import 'package:provider/provider.dart';

Widget buildAboutSection() {
  return const Center(
    child: Text('Album Section'),
  );
}

Widget buildAlbumSection() {
  return const Center(
    child: Text('Album Section'),
  );
}

Widget buildCoverPhoto(double coverHeight) {
  return Container(
    width: double.infinity,
    height: coverHeight,
    decoration: const BoxDecoration(
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
        image: const DecorationImage(
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
      const SizedBox(width: 5),
      Text(
        tag,
        style: const TextStyle(
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
    padding: const EdgeInsets.only(left: 10),
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
