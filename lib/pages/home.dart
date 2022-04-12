import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/bloc/netflixbar_bloc.dart';
import 'package:netflix_gallery/cubits/app_bar/app_bar_cubit.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/helpers/constants.dart';
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
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
          }
        },
        child: DefaultTabController(
            length: 3,
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  Navigator.pushReplacementNamed(context, "/error");
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
                                        onContentSelected(content)),
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
                                title: Constants.friends_headline,
                                onTap: (content) => onContentSelected(content),
                                contentList: state.friendsContent))
                        : const SliverToBoxAdapter(
                            child: LoadingContentList(
                                key: PageStorageKey('highlights'),
                                title: Constants.friends_headline,
                                highlighted: true)),
                    state is ContentLoaded
                        ? SliverToBoxAdapter(
                            child: ContentList(
                                key: const PageStorageKey('highlights'),
                                title: Constants.highlights_headline,
                                highlighted: true,
                                onContentSelected: (content) =>
                                    onContentSelected(content),
                                contentList: state.featuredContent))
                        : const SliverToBoxAdapter(
                            child: LoadingContentList(
                                key: PageStorageKey('highlights'),
                                title: Constants.highlights_headline,
                                highlighted: true)),
                    state is ContentLoaded
                        ? SliverToBoxAdapter(
                            child: AdaptiveLayout(
                            desktop: Container(),
                            mobile: ContentList(
                                key: const PageStorageKey('stefan'),
                                title: Constants.stefan_headline,
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
                                title: Constants.stefan_headline,
                                highlighted: false),
                          )),
                    state is ContentLoaded
                        ? SliverToBoxAdapter(
                            child: ContentList(
                                key: const PageStorageKey('all'),
                                title: Constants.library_headline,
                                highlighted: false,
                                onContentSelected: (content) =>
                                    onContentSelected(content),
                                contentList: state.allContent))
                        : const SliverToBoxAdapter(
                            child: LoadingContentList(
                                key: PageStorageKey('all'),
                                title: Constants.library_headline,
                                highlighted: true)),
                  ],
                );
              },
            )),
      );
    });
  }

  onContentSelected(Content content) {
    Navigator.of(context)
        .pushNamed("/profiles/home/play", arguments: VideoArgs(content));
  }
}
