import 'package:flutter/material.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';

class LoadingContentList extends StatelessWidget {
  final bool highlighted;
  final String title;

  const LoadingContentList(
      {Key? key, this.highlighted = false, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
            height: highlighted ? 500 : 220,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
                SliverToBoxAdapter(
                  child: LoadingCard(highlighted: highlighted),
                ),
              ],
            )),
      ]),
    );
  }
}
