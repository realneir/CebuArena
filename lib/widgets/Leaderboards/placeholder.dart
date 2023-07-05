import 'package:flutter/material.dart';

Widget buildPlaceholderContent(String mainCategory, String subCategory) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    color: Colors.white,
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 50, // or another height that suits your design
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Placeholder for ${mainCategory} - ${subCategory} TOP ${index + 1}',
            ),
          ),
        );
      },
    ),
  );
}
