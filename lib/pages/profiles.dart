import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class Profiles extends StatelessWidget {
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
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 64.0),
                child: SvgPicture.asset(
                  "assets/images/Netflix_2015_logo.svg",
                  width: 100,
                ),
              ),
              Container(
                height: constraints.maxHeight,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      Constants.profile_select_text,
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        height: 400,
                        width: constraints.maxWidth,
                        child: BlocBuilder<ProfilesBloc, ProfilesState>(
                          builder: (context, state) {
                            if (state is ProfilesInitial) {
                              return Center(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.profiles.length,
                                    itemBuilder: (context, index) {
                                      if (index == state.profiles.length - 1) {
                                        return ProfileCardWidget(
                                          name: state.profiles[index].name,
                                          profileImage: state
                                              .profiles[index].profileImage,
                                        );
                                      }
                                      return Row(
                                        children: [
                                          ProfileCardWidget(
                                            name: state.profiles[index].name,
                                            profileImage: state
                                                .profiles[index].profileImage,
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      );
                                    }),
                              );
                            }
                            return Container(
                                child: const Text(
                              "ARGH",
                              style: TextStyle(color: Colors.white),
                            ));
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

class ProfileCardWidget extends StatelessWidget {
  final String name;
  final Image profileImage;

  ProfileCardWidget({
    required this.name,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return OnHover(builder: (isHovered) {
      log("hover");
      return Column(
        children: [
          SizedBox(
            height: 206,
            width: 206,
            child: Container(
                decoration: BoxDecoration(
                    border: isHovered
                        ? Border.all(width: 6, color: Colors.white)
                        : Border.all(
                            width: 6, color: Constants.netflix_background)),
                child: profileImage),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(name,
                style: isHovered
                    ? TextStyle(color: Colors.white, fontSize: 20)
                    : TextStyle(color: Colors.grey, fontSize: 20)),
          ),
        ],
      );
    });
  }
}

class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const OnHover({Key? key, required this.builder}) : super(key: key);
  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: widget.builder(isHovered),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
