import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/helpers/constants.dart';
import 'package:netflix_gallery/navigation/home_args.dart';
import 'package:netflix_gallery/widgets/content_header.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';
import 'package:netflix_gallery/widgets/previews.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dipose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HomeArguments;

    return LayoutBuilder(builder: (context, constrains) {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Constants.netflix_background,
              appBar: PreferredSize(
                  preferredSize: Size(constrains.maxHeight, 50),
                  child: NetflixAppBar(
                    scrollOffset: _scrollOffset,
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
                ],
              )));
    });
  }
}
