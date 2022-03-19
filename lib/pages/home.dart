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
    final args = ModalRoute.of(context)!.settings.arguments as HomeArguments;
    BlocProvider.of<HomeBloc>(context).add(HomeRequestContent());

    return LayoutBuilder(builder: (context, constrains) {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Constants.netflix_background,
              appBar: PreferredSize(
                  preferredSize: Size(constrains.maxHeight, 50),
                  child: BlocBuilder<AppBarCubit, double>(
                    builder: (context, scrollOffset) {
                      return NetflixAppBar(
                        scrollOffset: scrollOffset,
                      );
                    },
                  )),
              body: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: ContentHeader(featuredContent: Content()),
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
                        onContentSelected: (content) => Navigator.of(context)
                            .pushNamed("/profiles/home/play",
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
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HighlightsLoaded) {
                        return SliverToBoxAdapter(
                          child: ContentList(
                              key: const PageStorageKey('highlights'),
                              title: "Highlights",
                              highlighted: true,
                              onContentSelected: (content) =>
                                  onContentSelected(content),
                              contentList: state.featuredContent),
                        );
                      }
                      return const SliverToBoxAdapter(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: ContentList(
                        key: const PageStorageKey('other'),
                        title: "Other",
                        onContentSelected: (content) => Navigator.of(context)
                            .pushNamed("/profiles/home/play",
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
              )));
    });
  }

  onContentSelected(Content content) {
    Navigator.of(context)
        .pushNamed("/profiles/home/play", arguments: VideoArgs(content));
  }
}
