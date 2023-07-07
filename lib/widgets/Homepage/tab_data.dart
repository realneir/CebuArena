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
    label: 'MLBB',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'VALORANT',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'DOTA 2',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'LOL',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'CODM',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
  TabData(
    label: 'WILDRIFT',
    icon: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('Ml.png'),
      backgroundColor: Colors.white,
    ),
  ),
];
