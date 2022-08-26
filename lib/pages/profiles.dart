import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/navigation/home_args.dart';
import 'package:netflix_gallery/widgets/animated_profile_card.dart';

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
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 36, left: 16),
                          child: Row(
                            children: [
                              _buildNetflixLogo(smallScreen),
                              Expanded(child: _buildSelectedText(20))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                    width: 250,
                                    child: _buildGridView(constraints)),
                              ),
                            ],
                          ),
                        )
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
                        margin: const EdgeInsets.only(top: 56, left: 16),
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
    return BlocBuilder<ProfilesBloc, ProfilesState>(
      buildWhen: (previous, current) => current is ProfilesInitial,
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
                          onTap: () => Navigator.of(context).pushNamed(
                              "/profiles/home",
                              arguments: HomeArguments(state.profiles[index]))),
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
    return BlocBuilder<ProfilesBloc, ProfilesState>(
      buildWhen: (previous, current) => current is ProfilesInitial,
      builder: (context, state) {
        if (state is ProfilesInitial) {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            scrollDirection: Axis.vertical,
            itemCount: state.profiles.length,
            itemBuilder: (context, index) {
              return AnimatedProfileCard(
                width: 80,
                fontSize: 10,
                name: state.profiles[index].name,
                profileImage: state.profiles[index].profileImage,
                onTap: () => Navigator.of(context).pushNamed("/profiles/home",
                    arguments: HomeArguments(state.profiles[index])),
              );
            },
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
}
