import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_assistant/Splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//https://dribbble.com/shots/15368753-Smart-Home-Dark-Mode-App

bool shouldUseFirestoreEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  runApp(MaterialApp(
    home: Splash(),
    theme: ThemeData(
      brightness: Brightness.dark,
      /* light theme settings */
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      /* dark theme settings */
    ),
    themeMode: ThemeMode.dark,
  ));
}

