import 'package:flutter/material.dart';

class Profile {
  String name;
  Image profileImage;
  int? profilePin; 

  Profile({required this.name, required this.profileImage, this.profilePin});
}
