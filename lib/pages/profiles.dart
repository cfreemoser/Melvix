import 'dart:developer';

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
                left: 64,
                child: SvgPicture.asset(
                  Constants.netflix_icon_full,
                  width: 100,
                ),
              ),
              Positioned(
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      Constants.profiles_select_text,
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        height: 300,
                        width: constraints.maxWidth,
                        child: BlocBuilder<ProfilesBloc, ProfilesState>(
                          builder: (context, state) {
                            if (state is ProfilesInitial) {
                              return Center(
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 300,
                                            childAspectRatio: 1.4,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.profiles.length,
                                    itemBuilder: (context, index) {
                                      return AnimatedProfileCard(
                                        name: state.profiles[index].name,
                                        profileImage:
                                            state.profiles[index].profileImage,
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}