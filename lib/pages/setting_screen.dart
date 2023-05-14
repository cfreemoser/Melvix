import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/upload_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:preload_page_view/preload_page_view.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settings = [
      BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          double progress = 0;
          String filename = "";

          if (state is QuickContentUploadedProgress) {
            progress = state.progress;
            filename = state.filename;
          } else {
            progress = 0;
            filename = "";
          }

          return _cardButton(
              context,
              "Quickcontent hochladen",
              "Quickvideos und photos hochladen",
              Icon(Icons.emoji_emotions),
              Image.asset(Constants.image_reaction_emoji),
              progressValue: progress,
              filename: filename,
              onTap: () => {
                    BlocProvider.of<UploadBloc>(context)
                        .add(UploadQuickContentEvent())
                  });
        },
      ),
      _cardButton(
        context,
        "Video hochladen",
        "Nieuve Melix film hochladen",
        Icon(Icons.play_arrow),
        Image.asset(Constants.image_construction),
      ),
      _cardButton(
        context,
        "Content verwalten",
        "Berarbeite melvix content",
        Icon(Icons.edit),
        Image.asset(Constants.image_construction),
      ),
    ];

    var _pageController =
        PreloadPageController(viewportFraction: 0.75, initialPage: 0);

    return Scaffold(
      backgroundColor: Constants.netflix_background,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: BlocListener<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state is QuickContentUploadedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Uploaded ' + state.filename),
                ),
              );
            }

            if (state is QuickContentUploadedFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Failed to upload ' + state.filename),
                ),
              );
            }
          },
          child: AdaptiveLayout(
            mobile: PreloadPageView(
              scrollDirection: Axis.horizontal,
              children: settings,
              controller: _pageController,
            ),
            desktop: ListView(
              scrollDirection: Axis.horizontal,
              children: settings,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardButton(BuildContext context, String title, String subtitle,
      Icon icon, Image mainImage,
      {Function()? onTap, String filename = "", double progressValue = 0}) {
    var enabled = onTap != null;

    var progress = SizedBox(
      height: AdaptiveLayout.isDesktop(context) ? 300 : 100,
      width: AdaptiveLayout.isDesktop(context) ? 300 : 100,
      child: LinearProgressIndicator(value: progressValue),
    );
    return Padding(
      padding: AdaptiveLayout.isDesktop(context)
          ? const EdgeInsets.all(32.0)
          : const EdgeInsets.only(top: 32, bottom: 32),
      child: SizedBox(
        width: 450,
        height: 300,
        child: Card(
            color: enabled ? Colors.white : Colors.grey.shade400,
            elevation: 8,
            child: BlocBuilder<UploadBloc, UploadState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: onTap,
                      child: Column(
                        children: [
                          ListTile(
                            leading: icon,
                            title: Text(title),
                            subtitle: Text(subtitle),
                          ),
                          Expanded(
                              child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: progressValue == 0 ? mainImage : progress,
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }
}
