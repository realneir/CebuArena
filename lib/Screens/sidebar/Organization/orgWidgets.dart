import 'package:flutter/material.dart';

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

Widget buildProfilePhoto(double profileHeight) {
  return Container(
    width: profileHeight,
    height: profileHeight,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      image: const DecorationImage(
        image: AssetImage('assets/Slider2.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildCoverPhoto(double coverHeight) {
  return Container(
    width: double.infinity,
    height: coverHeight,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/Slider1.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildTextWithPadding(String text, double size, FontWeight weight) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: weight),
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
