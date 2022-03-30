import 'package:flutter/widgets.dart';
import 'package:netflix_gallery/domain/content_ref.dart';
import 'package:netflix_gallery/domain/profile.dart';
import 'package:netflix_gallery/domain/quick_content_ref.dart';
import 'package:yaml/yaml.dart';

class Config {
  late List<ProfileConfig> _profiles;
  late List<ContentRef> _featuredContent;
  late List<ContentRef> _top;
  late QuickContentRef _quickContentRef;
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
    var conf = Config();

    final dynamic yamlMap = loadYaml(jsonConfig);
    YamlList profileConfig = yamlMap['Profiles'];
    conf._profiles = profileConfig
        .map((element) => ProfileConfig(
              element['name'],
              element['assetURL'],
              element['assetID'],
              element['pinCode'],
            ))
        .toList();

    conf._featuredContent = loadListFromConfig(yamlMap, "Highlights");
    conf._top = loadListFromConfig(yamlMap, "Top");

    String quickContentRef = yamlMap['QuickContentPath'];
    conf._quickContentRef = QuickContentRef(storagePath: quickContentRef);

    _config = conf;
  }

  List<Profile> getProfilesFromConfig() {
    return _config._profiles.map(_mapProfileConfigToProfile).toList();
  }

  List<ContentRef> getFeaturedContentFromConfig() {
    return _config._featuredContent;
  }

  List<ContentRef> getTopContentFromConfig() {
    return _config._top;
  }

  QuickContentRef getQuickContentRef() {
    return _config._quickContentRef;
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

  List<ContentRef> loadListFromConfig(dynamic yamlMap, String configKey) {
    YamlList featuredContentConfig = yamlMap[configKey];
    return featuredContentConfig
        .map((element) => ContentRef(
              headerImagePath: element['headerImage'],
              videoURLPath: element['video'],
              title: element['title'],
              titleSvgPath: null,
            ))
        .toList();
  }
}
