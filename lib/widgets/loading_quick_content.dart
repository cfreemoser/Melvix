import 'package:flutter/material.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';

class LoadingQuickContent extends StatelessWidget {
  const LoadingQuickContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int itemIndex) {
        return const FittedBox(
            fit: BoxFit.cover,
            child: LoadingCard(
              highlighted: false,
            ));
      },
    );
  }
}
