import 'package:flutter/material.dart';
import 'package:netflix_gallery/widgets/loading_top_content_list.dart';
import 'package:shimmer/shimmer.dart';

class LoadingContentHeader extends StatelessWidget {
  final double hight;
  final double width;

  const LoadingContentHeader({
    Key? key,
    required this.hight,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: hight,
      child: Stack(children: [
        Positioned.fill(
            child: Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 55, 53, 53),
                highlightColor: const Color.fromARGB(255, 109, 108, 108),
                child: SizedBox(
                  height: hight,
                  width: width,
                  child: Container(
                    color: Colors.white,
                  ),
                ))),
        Positioned(
            bottom: 0,
            child: SizedBox(
              height: 300,
              width: width,
              child: const LoadingTopContentList(title: "Top 10"),
            )),
      ]),
    );
  }
}
