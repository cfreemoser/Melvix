import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/bloc/netflixbar_bloc.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/navigation/video_args.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';
import 'package:netflix_gallery/widgets/content_header.dart';
import 'package:netflix_gallery/widgets/content_list.dart';
import 'package:netflix_gallery/widgets/loading_content_header.dart';
import 'package:netflix_gallery/widgets/loading_content_list.dart';
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
        BlocProvider.of<NetflixbarBloc>(context).add(
            NetflixbarScrollOffsetChanged(offset: _scrollController.offset));
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
      BlocProvider.of<NetflixbarBloc>(context).add(NetflixbarConstrainsChanged(
          mobile: AdaptiveLayout.isMobile(context),
          maxHeight: constrains.maxHeight));
      return BlocListener<NetflixbarBloc, NetflixbarState>(
        listener: (context, state) {
          if (state is NetflixbarOffsetRequested) {
            _scrollController.animateTo(state.offset,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
          }
        },
        child: DefaultTabController(
            length: 3,
            child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is ErrorState) {
                    Navigator.pushReplacementNamed(context, "/error");
                  }
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) =>
                          current is HomeInitial ||
                          current is TopContentUpdated,
                      builder: (context, state) {
                        if (state is TopContentUpdated) {
                          return SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                ContentHeader(
                                    topContent: (state).topContent,
                                    hight: constrains.maxHeight,
                                    width: constrains.maxWidth,
                                    onContentSelected: (content) =>
                                        onContentSelected(content)),
                              ],
                            ),
                          );
                        }
                        return SliverToBoxAdapter(
                            child: LoadingContentHeader(
                          hight: constrains.maxHeight,
                          width: constrains.maxWidth,
                        ));
                      },
                    ),
                    BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) =>
                          current is HomeInitial ||
                          current is FriendsContentUpdated,
                      builder: (context, state) {
                        if (state is FriendsContentUpdated) {
                          return SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                Previews(
                                    key: const PageStorageKey('friends'),
                                    title: Constants.friends_headline,
                                    onTap: (content) =>
                                        onContentSelected(content),
                                    contentList: state.friendsContent),
                              ],
                            ),
                          );
                        }
                        return SliverToBoxAdapter(
                            child: LoadingContentHeader(
                          hight: constrains.maxHeight,
                          width: constrains.maxWidth,
                        ));
                      },
                    ),
                    BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) =>
                          current is HomeInitial ||
                          current is FeaturedContentUpdated,
                      builder: (context, state) {
                        if (state is FeaturedContentUpdated) {
                          return SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                ContentList(
                                    key: const PageStorageKey('highlights'),
                                    title: Constants.highlights_headline,
                                    highlighted: true,
                                    onContentSelected: (content) =>
                                        onContentSelected(content),
                                    contentList: state.featuredContent)
                              ],
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(
                            child: LoadingContentList(
                          title: Constants.highlights_headline,
                          highlighted: true,
                        ));
                      },
                    ),
                    SliverToBoxAdapter(
                        child: AdaptiveLayout(
                      desktop: Container(),
                      mobile: BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (previous, current) =>
                            current is HomeInitial ||
                            current is StefanContentUpdated,
                        builder: (context, state) {
                          if (state is StefanContentUpdated) {
                            return Stack(
                              children: [
                                SliverToBoxAdapter(
                                  child: ContentList(
                                      key: const PageStorageKey('stefan'),
                                      title: Constants.stefan_headline,
                                      highlighted: false,
                                      onContentSelected: (content) =>
                                          onContentSelected(content),
                                      contentList: state.stefanContent),
                                ),
                              ],
                            );
                          }
                          return const LoadingContentList(
                            title: Constants.stefan_headline,
                            highlighted: false,
                          );
                        },
                      ),
                    )),
                    BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) =>
                          current is HomeInitial ||
                          current is AllContentUpdated,
                      builder: (context, state) {
                        if (state is AllContentUpdated) {
                          return SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                ContentList(
                                    key: const PageStorageKey('all'),
                                    title: Constants.library_headline,
                                    highlighted: false,
                                    onContentSelected: (content) =>
                                        onContentSelected(content),
                                    contentList: state.allContent)
                              ],
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(
                            child: LoadingContentList(
                          title: Constants.library_headline,
                          highlighted: false,
                        ));
                      },
                    ),
                  ],
                ))),
      );
    });
  }

  onContentSelected(Content content) {
    Navigator.of(context)
        .pushNamed("/profiles/home/play", arguments: VideoArgs(content));
  }
}
