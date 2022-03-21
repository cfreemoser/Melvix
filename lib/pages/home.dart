import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/cubits/app_bar/app_bar_cubit.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/navigation/home_args.dart';
import 'package:netflix_gallery/navigation/video_args.dart';
import 'package:netflix_gallery/widgets/content_header.dart';
import 'package:netflix_gallery/widgets/content_list.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';
import 'package:netflix_gallery/widgets/previews.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<Home> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        BlocProvider.of<AppBarCubit>(context)
            .setOffset(_scrollController.offset);
      });
    super.initState();
  }

  @override
  void dipose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  BlocProvider.of<HomeBloc>(context).add(HighlightsRequested());
    BlocProvider.of<HomeBloc>(context).add(TopRequested());

    return LayoutBuilder(builder: (context, constrains) {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black,
              appBar: PreferredSize(
                  preferredSize: Size(constrains.maxWidth, 50),
                  child: BlocBuilder<AppBarCubit, double>(
                    builder: (context, scrollOffset) {
                      return NetflixAppBar(
                        scrollOffset: scrollOffset,
                      );
                    },
                  )),
              body: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      state is TopLoaded
                          ? SliverToBoxAdapter(
                              child: Stack(
                                children: [
                                  ContentHeader(
                                      topContent: state.topContent,
                                      hight: constrains.maxHeight,
                                      width: constrains.maxWidth,
                                      onContentSelected: (content) =>
                                          Navigator.pushNamed(
                                              context, "/profiles/home/play",
                                              arguments: VideoArgs(content))),
                                ],
                              ),
                            )
                          : const SliverToBoxAdapter(
                              child: CircularProgressIndicator(),
                            ),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 20),
                        sliver: SliverToBoxAdapter(
                          child: Previews(
                            key: const PageStorageKey('previews'),
                            title: "privews",
                            contentList: [
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content()
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ContentList(
                            key: const PageStorageKey('myList'),
                            title: "My List",
                            onContentSelected: (content) =>
                                Navigator.of(context).pushNamed(
                                    "/profiles/home/play",
                                    arguments: VideoArgs(content)),
                            contentList: [
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content()
                            ]),
                      ),
                      state is HighlightsLoaded
                          ? SliverToBoxAdapter(
                              child: ContentList(
                                  key: const PageStorageKey('highlights'),
                                  title: "Highlights",
                                  highlighted: true,
                                  onContentSelected: (content) =>
                                      onContentSelected(content),
                                  contentList: state.featuredContent),
                            )
                          : const SliverToBoxAdapter(
                              child: CircularProgressIndicator(),
                            ),
                      SliverToBoxAdapter(
                        child: ContentList(
                            key: const PageStorageKey('other'),
                            title: "Other",
                            onContentSelected: (content) =>
                                Navigator.of(context).pushNamed(
                                    "/profiles/home/play",
                                    arguments: VideoArgs(content)),
                            contentList: [
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content(),
                              Content()
                            ]),
                      )
                    ],
                  );
                },
              )));
    });
  }

  onContentSelected(Content content) {
    Navigator.of(context)
        .pushNamed("/profiles/home/play", arguments: VideoArgs(content));
  }
}
