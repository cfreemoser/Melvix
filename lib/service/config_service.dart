import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:netflix_gallery/domain/profile.dart';

class Config {
  late List<ProfileConfig> _profiles;

  Config.fromJson(Map<String, dynamic> json) {
    _profiles = (json['profiles'] as List)
        .map((e) => ProfileConfig.fromJson(e))
        .toList();
  }
}

class ProfileConfig {
  final String name;
  final String? imageURL;
  final String? assetID;
  final int? pinCode;

  ProfileConfig(this.name, this.imageURL, this.assetID, this.pinCode);

  ProfileConfig.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageURL = json['imageURL'],
        assetID = json['assetID'],
        pinCode = json['pinCode'];
}

class ConfigService {
  late Config _config;

  void loadConfigFromJson(String jsonConfig) async {
    _config = Config.fromJson(json.decode(jsonConfig));
  }

  List<Profile> getProfilesFromConfig() {
    return _config._profiles.map(_mapProfileConfigToProfile).toList();
  }

  Profile _mapProfileConfigToProfile(ProfileConfig profileConfig) {
    Image image = profileConfig.assetID == null
        ? Image.network(profileConfig.imageURL!)
        : Image.asset(profileConfig.assetID!);

    return Profile(
        name: profileConfig.name,
        profilePin: profileConfig.pinCode,
        profileImage: image);
  }
}
