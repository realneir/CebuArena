import 'package:flutter/material.dart';

class TabData {
  final String label;
  final Widget icon;

  TabData({
    required this.label,
    required this.icon,
  });
}

List<TabData> tabs = [
  TabData(
    label: 'Mobile Legends',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'Mobile Legends',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'Mobile Legends',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'Mobile Legends',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
];
