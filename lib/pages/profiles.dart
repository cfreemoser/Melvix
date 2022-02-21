import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/animated_profile_card.dart';

class Profiles extends StatelessWidget {
  const Profiles({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool smallScreen = constraints.maxWidth < 600;
          double netflixLogoHeight = 40;
          double selectTextHeight = 40;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black,
                      Constants.netflix_background,
                      Constants.netflix_background
                    ])),
                height: constraints.maxHeight,
                width: constraints.maxWidth,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding:
                          EdgeInsets.only(top: 20, left: smallScreen ? 16 : 64),
                      child: SvgPicture.network(
                        smallScreen
                            ? "https://upload.wikimedia.org/wikipedia/commons/0/0c/Netflix_2015_N_logo.svg"
                            : "https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg",
                        width: smallScreen ? 20 : 100,
                        height: netflixLogoHeight,
                        semanticsLabel: "netflix icon",
                        placeholderBuilder: (context) =>
                            const Text("loading..."),
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        top: smallScreen ? 80 : constraints.maxHeight / 4,
                        bottom: 20),
                    child: const Center(
                      child: Text(
                        Constants.profiles_select_text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ProfilesBloc, ProfilesState>(
                      builder: (context, state) {
                        if (state is ProfilesInitial) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Center(
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio:
                                              smallScreen ? 5 / 5 : 3,
                                          crossAxisCount: smallScreen ? 2 : 1),
                                  shrinkWrap: true,
                                  scrollDirection: smallScreen
                                      ? Axis.vertical
                                      : Axis.horizontal,
                                  itemCount: state.profiles.length,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  itemBuilder: (context, index) {
                                    return AnimatedProfileCard(
                                      width: smallScreen ? 100 : 200,
                                      fontSize: 20,
                                      name: state.profiles[index].name,
                                      profileImage:
                                          state.profiles[index].profileImage,
                                    );
                                  }),
                            ),
                          );
                        }
                        return const Text(
                          Constants.profiles_empty,
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  )
                ],
              ))
            ],
          );
        },
      ),
    );
  }
}
