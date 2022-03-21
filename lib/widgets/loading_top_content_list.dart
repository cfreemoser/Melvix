import 'package:flutter/material.dart';
import 'package:netflix_gallery/widgets/border_boxed_text.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';

class LoadingTopContentList extends StatelessWidget {
  final String title;

  const LoadingTopContentList({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 32, left: 60),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: _placeHolders(),
          ),
        ),
      ]),
    );
  }

  List<SliverToBoxAdapter> _placeHolders() {
    var obj = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    List<SliverToBoxAdapter> list = [];
    for (var prop in obj) {
      var widget = SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          width: 240,
          height: 200,
          child: Stack(
            children: [
              SizedBox(
                  width: 150,
                  height: double.infinity,
                  child: BorderBoxedText(
                    hight: 100,
                    width: 70,
                    text: (prop.toString()),
                  )),
              const Positioned(
                left: 95,
                child: LoadingCard(highlighted: false),
              ),
            ],
          ),
        ),
      );
      list.add(widget);
    }
    return list;
  }
}
