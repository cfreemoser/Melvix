import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/auth_bloc.dart';
import 'package:netflix_gallery/bloc/error_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/bloc/quick_content_bloc.dart';
import 'package:netflix_gallery/bloc/upload_bloc.dart';
import 'package:netflix_gallery/pages/error_screen.dart';
import 'package:netflix_gallery/pages/login.dart';
import 'package:netflix_gallery/pages/nav_screen.dart';
import 'package:netflix_gallery/pages/profiles.dart';
import 'package:netflix_gallery/pages/video.dart';
import 'package:netflix_gallery/service/authentication_service.dart';
import 'package:netflix_gallery/service/config_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:netflix_gallery/service/firestore_service.dart';
import 'package:netflix_gallery/service/secret_service.dart';
import 'package:netflix_gallery/service/storage_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Right before you would be doing any loading
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LekSxQfAAAAAPcke75fM4myrV-EpvT_anEZMokK',
  );

  String configYaml = await rootBundle.loadString("assets/config.yaml");

  dynamic app = MyApp(
    configYaml: configYaml,
  );

  runApp(app);
}

class MyApp extends StatefulWidget {
  final String configYaml;

  const MyApp({
    Key? key,
    required this.configYaml,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConfigService configService;
  late StorageService storageService;
  late AuthenticationService authenticationService;
  late FirestoreService firestoreService;
  late SecretService secretService;

  @override
  void initState() {
    configService = ConfigService();
    storageService = StorageService();
    firestoreService = FirestoreService();
    authenticationService = AuthenticationService();
    secretService = SecretService();
    configService.loadConfigFromYaml(widget.configYaml);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melvix',
      initialRoute: "/login",
      routes: {
        "/error": (context) => BlocProvider(
            create: (context) => ErrorBloc(), child: ErrorScreen()),
        "/login": (context) => BlocProvider(
            create: (context) => AuthBloc(authenticationService, secretService)
              ..add(InitRequested()),
            child: Login()),
        "/profiles": (context) => BlocProvider(
              create: (context) => ProfilesBloc(configService),
              child: const Profiles(),
            ),
        "/profiles/home": (context) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => HomeBloc(storageService, firestoreService),
              ),
              BlocProvider(
                create: (context) =>
                    QuickContentBloc(configService, storageService),
              ),
              BlocProvider(
                  create: (context) => UploadBloc(
                      storageService, firestoreService, configService))
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
          primarySwatch: Colors.red),
    );
  }
}
