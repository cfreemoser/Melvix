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
    return LayoutBuilder(builder: (context, constraints) {
      bool smallScreen = constraints.maxWidth < 600;
      developer.log(smallScreen.toString());

      double topCenterDistance = smallScreen
          ? constraints.maxHeight * 0.3
          : constraints.maxHeight * 0.5;

      return Scaffold(
        body: SizedBox(
          height: constraints.minHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                color: Constants.netflix_background,
              ),
              Positioned(
                top: 16,
                left: smallScreen ? 16 : 64,
                child: SvgPicture.network(
                  smallScreen
                      ? Constants.netflix_icon_small
                      : Constants.netflix_icon_full,
                  width: smallScreen ? 20 : 100,
                  semanticsLabel: "netflix icon",
                  placeholderBuilder: (context) => const Text("loading..."),
                ),
              ),
              Positioned(
                  top: topCenterDistance - 32 - 150,
                  width: constraints.maxWidth,
                  height: 40,
                  child: const Center(
                    child: Text(
                      Constants.profiles_select_text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  )),
              Positioned(
                height: constraints.maxHeight - topCenterDistance,
                width: constraints.maxWidth,
                top: (topCenterDistance + 40) - 150,
                child: Center(
                  child: BlocBuilder<ProfilesBloc, ProfilesState>(
                    builder: (context, state) {
                      if (state is ProfilesInitial) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 0,
                                      childAspectRatio: smallScreen ? 0.8 : 3,
                                      crossAxisCount: smallScreen ? 2 : 1),
                              shrinkWrap: true,
                              scrollDirection:
                                  smallScreen ? Axis.vertical : Axis.horizontal,
                              itemCount: state.profiles.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => developer.log("hallo"),
                                  child: AnimatedProfileCard(
                                    width: 120,
                                    fontSize: 20,
                                    name: state.profiles[index].name,
                                    profileImage:
                                        state.profiles[index].profileImage,
                                  ),
                                );
                              }),
                        );
                      }
                      return const Text(
                        Constants.profiles_empty,
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
