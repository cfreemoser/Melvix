import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/profiles_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/widgets/animated_profile_card.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

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
        if (state is ProfileSelectedState) {
          _buildPinDialog(context);
        }
      },
      buildWhen: (prev, curr) => curr is ProfilesInitial,
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
                            .add(ProfileSelected()),
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
        if (state is ProfileSelectedState) {
          _buildPinDialog(context);
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
                          .add(ProfileSelected()),
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
      Image.asset(
        smallScreen
            ? Constants.netflix_icon_small
            : Constants.netflix_icon_full,
        height: 40,
      )
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

  Future<void> _buildPinDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(Constants.profiles_pin_text),
            backgroundColor: Constants.netflix_background,
            titleTextStyle: const TextStyle(
                color: Colors.white, fontFamily: "NetflixSans", fontSize: 20),
            actions: <Widget>[
              TextButton(
                child: const Text(Constants.profiles_forgot_text,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "NetflixSans",
                        fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: PinCodeTextField(
              autofocus: true,
              hideCharacter: true,
              highlight: true,
              highlightColor: Colors.grey,
              defaultBorderColor: Colors.grey,
              hasTextBorderColor: Constants.netflix_background,
              pinBoxColor: Colors.white,
              maskCharacter: "*",
              maxLength: 4,
              pinBoxWidth: 50,
              pinBoxHeight: 64,
              hasUnderline: true,
              wrapAlignment: WrapAlignment.spaceAround,
              pinBoxDecoration:
                  ProvidedPinBoxDecoration.defaultPinBoxDecoration,
              pinTextStyle: const TextStyle(fontSize: 22.0),
              pinTextAnimatedSwitcherTransition:
                  ProvidedPinBoxTextAnimation.scalingTransition,
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
              highlightAnimationBeginColor: Colors.black,
              highlightAnimationEndColor: Colors.white12,
              keyboardType: TextInputType.number,
            ),
          );
        });
  }
}
