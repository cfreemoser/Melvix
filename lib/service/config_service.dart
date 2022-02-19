import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:netflix_gallery/domain/profile.dart';

class Config {
  late List<ProfileConfig> _profiles;

  Config.fromJson(Map<String, dynamic> json) {
    _profiles = (json['profiles'] as List).map((e) => ProfileConfig.fromJson(e)).toList();
  }
}

class ProfileConfig {
  final String name;
  final String? imageURL;
  final String? assetID;

  ProfileConfig(this.name, this.imageURL, this.assetID);

  ProfileConfig.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageURL = json['imageURL'],
        assetID = json['assetID'];
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
    if (profileConfig.assetID == null) {
      return Profile(
          name: profileConfig.name,
          profileImage: Image.network(profileConfig.imageURL!));
    }

    return Profile(
        name: profileConfig.name,
        profileImage: Image.asset(profileConfig.assetID!));
  }
}
