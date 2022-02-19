import 'package:flutter/material.dart';
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
                        width: 400,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [ProfileCardWidget(), ProfileCardWidget()],
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
  const ProfileCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: Image.asset("assets/images/Netflix-avatar.png"),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Text("Cem", style: TextStyle(color: Colors.grey, fontSize: 20)),
        ),
      ],
    );
  }
}
