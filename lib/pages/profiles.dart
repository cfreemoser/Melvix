import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/domain/profile.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/navigation/home_args.dart';
import 'package:netflix_gallery/widgets/animated_profile_card.dart';
import 'package:netflix_gallery/widgets/pin_dialog.dart';

class Profiles extends StatelessWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.netflix_background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool smallScreen = constraints.maxWidth < 600;
          if (smallScreen) {
            return Stack(
              children: [
                _buildBackground(constraints.maxHeight, constraints.maxWidth),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 16),
                          child: Row(
                            children: [
                              _buildNetflixLogo(smallScreen),
                              Expanded(child: _buildSelectedText(20))
                            ],
                          ),
                        ),
                        Expanded(child: _buildGridView(constraints))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Stack(
            children: [
              _buildBackground(constraints.maxHeight, constraints.maxWidth),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 16),
                        child: Row(
                          children: [
                            _buildNetflixLogo(smallScreen),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 400,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 32),
                                  child: _buildSelectedText(40),
                                ),
                                Expanded(
                                    child: Center(
                                        child: _buildListView(constraints)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView(BoxConstraints constraints) {
    return BlocConsumer<ProfilesBloc, ProfilesState>(
      listener: (context, state) {
        if (state is PinSecuredProfileSelected) {
          _buildPinDialog(context, state.profile);
        }
        if (state is PinCorrect) {
          Navigator.of(context).pushNamed("/profiles/home",
              arguments: HomeArguments(state.profile));
        }
      },
      builder: (context, state) {
        if (state is ProfilesInitial) {
          return Center(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.profiles.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      AnimatedProfileCard(
                        width: 200,
                        fontSize: 20,
                        name: state.profiles[index].name,
                        profileImage: state.profiles[index].profileImage,
                        onTap: () => BlocProvider.of<ProfilesBloc>(context)
                            .add(ProfileSelected(state.profiles[index])),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  );
                }),
          );
        }
        return const Text(
          Constants.profiles_empty,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget _buildGridView(BoxConstraints constraints) {
    return BlocConsumer<ProfilesBloc, ProfilesState>(
      listener: (context, state) {
        if (state is PinSecuredProfileSelected) {
          _buildPinDialog(context, state.profile);
        }
      },
      buildWhen: (previous, current) => current is ProfilesInitial,
      builder: (context, state) {
        if (state is ProfilesInitial) {
          return SizedBox(
            width: constraints.maxWidth,
            child: Center(
                child: SizedBox(
              width: constraints.maxWidth * 0.6,
              height: 300,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.6 / 2.4, crossAxisCount: 2),
                  scrollDirection: Axis.vertical,
                  itemCount: state.profiles.length,
                  itemBuilder: (context, index) {
                    return AnimatedProfileCard(
                      width: 80,
                      fontSize: 10,
                      name: state.profiles[index].name,
                      profileImage: state.profiles[index].profileImage,
                      onTap: () => BlocProvider.of<ProfilesBloc>(context)
                          .add(ProfileSelected(state.profiles[index])),
                    );
                  }),
            )),
          );
        }
        return const Text(
          Constants.profiles_empty,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget _buildBackground(double height, double width) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Constants.netflix_background,
            Constants.netflix_background
          ],
        ),
      ),
      height: height,
      width: width,
    );
  }

  Widget _buildNetflixLogo(bool smallScreen) {
    return SizedBox(
        child: Row(children: [
      SvgPicture.asset(
          smallScreen
              ? Constants.netflix_icon_small
              : Constants.netflix_icon_full,
          height: 40)
    ]));
  }

  Widget _buildSelectedText(double fontSize) {
    return Text(
      Constants.profiles_select_text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: fontSize, fontFamily: "NetflixSans"),
    );
  }

  Future<void> _buildPinDialog(BuildContext ctx, Profile profile) async {
    return showDialog<void>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PinDialog(
            targetPin: profile.profilePin!,
            onSuccess: () {
              Navigator.of(context, rootNavigator: true).pop();
              BlocProvider.of<ProfilesBloc>(ctx).add(
                ProfilePinEntered(profile),
              );
            },
          );
        });
  }
}
