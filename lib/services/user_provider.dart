// ignore: depend_on_referenced_packages
import 'package:captsone_ui/Screens/Homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// final currentIndexProvider = StateNotifierProvider<CurrentIndexNotifier, int>(
//     (ref) => CurrentIndexNotifier());

final scaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});
