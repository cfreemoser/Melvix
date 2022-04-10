import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/cubits/app_bar/app_bar_cubit.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/navigation/video_args.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/content_header.dart';
import 'package:netflix_gallery/widgets/content_list.dart';
import 'package:netflix_gallery/widgets/loading_content_header.dart';
import 'package:netflix_gallery/widgets/loading_content_list.dart';
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
                        allTap: () => setState(() {
                          _scrollController.animateTo(
                              AdaptiveLayout.isMobile(context) ? 1500 : 1500,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }),
                        highlightsTap: () => setState(() {
                          _scrollController.animateTo(
                              AdaptiveLayout.isMobile(context) ? 1100 : 1500,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }),
                        friendsTap: () => setState(() {
                          _scrollController.animateTo(
                              AdaptiveLayout.isMobile(context) ? 750 : 1000,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }),
                        topTenTap: () => setState(() {
                          _scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }),
                        myListTap: () => setState(() {
                          _scrollController.animateTo(
                              AdaptiveLayout.isMobile(context) ? 950 : 1200,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }),
                      );
                    },
                  )),
              body: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is ErrorState) {
                    Navigator.pushNamed(context, "/error");
                  }
                },
                builder: (context, state) {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      state is ContentLoaded
                          ? SliverToBoxAdapter(
                              child: Stack(
                                children: [
                                  ContentHeader(
                                      topContent:
                                          (state as ContentLoaded).topContent,
                                      hight: constrains.maxHeight,
                                      width: constrains.maxWidth,
                                      onContentSelected: (content) =>
                                          Navigator.pushNamed(
                                              context, "/profiles/home/play",
                                              arguments: VideoArgs(content))),
                                ],
                              ),
                            )
                          : SliverToBoxAdapter(
                              child: LoadingContentHeader(
                                hight: constrains.maxHeight,
                                width: constrains.maxWidth,
                              ),
                            ),
                      state is ContentLoaded
                          ? SliverToBoxAdapter(
                              child: Previews(
                                  key: const PageStorageKey('friends'),
                                  title: "Friends & Family",
                                  contentList: state.friendsContent))
                          : const SliverToBoxAdapter(
                              child: LoadingContentList(
                                  key: PageStorageKey('highlights'),
                                  title: "test",
                                  highlighted: true)),
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
                      state is ContentLoaded
                          ? SliverToBoxAdapter(
                              child: ContentList(
                                  key: const PageStorageKey('highlights'),
                                  title: "Highlights",
                                  highlighted: true,
                                  onContentSelected: (content) =>
                                      onContentSelected(content),
                                  contentList: state.featuredContent))
                          : const SliverToBoxAdapter(
                              child: LoadingContentList(
                                  key: PageStorageKey('highlights'),
                                  title: "test",
                                  highlighted: true)),
                      state is ContentLoaded
                          ? SliverToBoxAdapter(
                              child: AdaptiveLayout(
                              desktop: Container(),
                              mobile: ContentList(
                                  key: const PageStorageKey('stefan'),
                                  title: "Films van Stefan",
                                  highlighted: false,
                                  onContentSelected: (content) =>
                                      onContentSelected(content),
                                  contentList: state.stefanContent),
                            ))
                          : SliverToBoxAdapter(
                              child: AdaptiveLayout(
                              desktop: Container(),
                              mobile: const LoadingContentList(
                                  key: PageStorageKey('stefan'),
                                  title: "test",
                                  highlighted: false),
                            )),
                      state is ContentLoaded
                          ? SliverToBoxAdapter(
                              child: ContentList(
                                  key: const PageStorageKey('all'),
                                  title: "Library",
                                  highlighted: false,
                                  onContentSelected: (content) =>
                                      onContentSelected(content),
                                  contentList: state.allContent))
                          : const SliverToBoxAdapter(
                              child: LoadingContentList(
                                  key: PageStorageKey('all'),
                                  title: "Library",
                                  highlighted: true)),
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
