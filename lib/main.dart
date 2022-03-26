import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/auth_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/bloc/quick_content_bloc.dart';
import 'package:netflix_gallery/pages/login.dart';
import 'package:netflix_gallery/pages/nav_screen.dart';
import 'package:netflix_gallery/pages/profiles.dart';
import 'package:netflix_gallery/pages/video.dart';
import 'package:netflix_gallery/service/authentication_service.dart';
import 'package:netflix_gallery/service/config_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:netflix_gallery/service/storage_service.dart';
import 'package:video_player/video_player.dart';
import 'firebase_options.dart';

void main() async {
  // Right before you would be doing any loading
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ConfigService myConfigService = ConfigService();
  StorageService myStorageService = StorageService();
  AuthenticationService myAuthenticationService = AuthenticationService();
  String configYaml = await rootBundle.loadString("assets/config.yaml");
  myConfigService.loadConfigFromYaml(configYaml);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LekSxQfAAAAAPcke75fM4myrV-EpvT_anEZMokK',
  );

  dynamic app = MyApp(
    configService: myConfigService,
    storageService: myStorageService,
    authenticationService: myAuthenticationService,
  );

  runApp(app);
}

class MyApp extends StatelessWidget {
  final ConfigService configService;
  final StorageService storageService;
  final AuthenticationService authenticationService;

  const MyApp(
      {Key? key,
      required this.configService,
      required this.storageService,
      required this.authenticationService})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melvix',
      initialRoute: "/login",
      routes: {
        "/login": (context) => BlocProvider(
            create: (context) =>
                AuthBloc(authenticationService)..add(InitRequested()),
            child: Login()),
        "/profiles": (context) => BlocProvider(
              create: (context) => ProfilesBloc(configService),
              child: const Profiles(),
            ),
        "/profiles/home": (context) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => HomeBloc(configService, storageService),
              ),
              BlocProvider(
                create: (context) =>
                    QuickContentBloc(configService, storageService),
              ),
            ], child: NavScreen()),
        "/profiles/home/play": (context) => const Video(),
      },
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
          fontFamily: "NetflixSans"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final StorageService myStorageService;
  const MyHomePage(
      {Key? key, required this.title, required this.myStorageService})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: TestWidget(
            myStorageService: widget
                .myStorageService) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class TestWidget extends StatefulWidget {
  final StorageService myStorageService;
  late VideoPlayerController _controller;

  TestWidget({Key? key, required this.myStorageService}) : super(key: key);

  @override
  _TestWidgetState createState() {
    var state = _TestWidgetState();
    return state;
  }
}

class _TestWidgetState extends State<TestWidget> {
  String? test = null;
  @override
  Widget build(BuildContext context) {
    if (test == null) {
      return Container(
        height: 100,
        width: 100,
      );
    }

    return Column(
      children: [
        Image.network(test!),
        AspectRatio(
          aspectRatio: widget._controller.value.aspectRatio,
          child: VideoPlayer(widget._controller),
        )
      ],
    );
  }
}
