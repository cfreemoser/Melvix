import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:netflix_gallery/domain/profile.dart';
import 'package:yaml/yaml.dart';

class Config {
  late List<ProfileConfig> _profiles;
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

  void loadConfigFromYaml(String jsonConfig) {
    final dynamic yamlMap = loadYaml(jsonConfig);
    YamlList profileConfig = yamlMap['Profiles'];
    var tmp = profileConfig
        .map((element) => ProfileConfig(
              element['name'],
              element['assetURL'],
              element['assetID'],
              element['pinCode'],
            ))
        .toList();
    var conf = Config();
    conf._profiles = tmp;
    _config = conf;
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
