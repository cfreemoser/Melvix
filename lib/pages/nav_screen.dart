import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/home_bloc.dart';
import 'package:netflix_gallery/bloc/netflixbar_bloc.dart';
import 'package:netflix_gallery/cubits/app_bar/app_bar_cubit.dart';
import 'package:netflix_gallery/pages/home.dart';
import 'package:netflix_gallery/pages/quick_content_screen.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';

import '../widgets/netflix_app_bar.dart';

class NavScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NaveScreenState();
}

class _NaveScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    const Home(
      key: PageStorageKey('homeScreen'),
    ),
    QuickContentScreen(),
    const Scaffold()
  ];

  final Map<String, IconData> _icons = const {
    'home': Icons.home,
    'Schnelle Lacher': Icons.photo_album,
    'search': Icons.search,
  };

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider<NetflixbarBloc>(
        create: (_) => NetflixbarBloc(),
        child: LayoutBuilder(
          builder: (context, constraints) => Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black,
              appBar: _selectedIndex == 0 || AdaptiveLayout.isDesktop(context)
                  ? PreferredSize(
                      preferredSize: Size(constraints.maxWidth, 50),
                      child: BlocConsumer<NetflixbarBloc, NetflixbarState>(
                        listener: (context, state) {
                          if (state is NetflxbarEnsureHomePage) {
                            BlocProvider.of<HomeBloc>(context)
                                .add(ContentRequested());
                            setState(() {
                              _selectedIndex = 0;
                            });
                          }
                          if (state is NetflixbarOffsetChanged) {
                            setState(() {
                              _selectedIndex = state.section ==
                                      SelectedSection.quickLaughters
                                  ? 1
                                  : 0;
                            });
                          }
                        },
                        builder: (context, state) {
                          return NetflixAppBar(
                            scrollOffset: state is NetflixbarOffsetChanged
                                ? state.offset
                                : 0,
                            selectedIndex: state is NetflixbarOffsetChanged
                                ? state.section.index
                                : 0,
                            allTap: () =>
                                BlocProvider.of<NetflixbarBloc>(context)
                                    .add(NetflixbarAllRequested()),
                            highlightsTap: () =>
                                BlocProvider.of<NetflixbarBloc>(context)
                                    .add(NetflixbarHighlightsRequested()),
                            friendsTap: () =>
                                BlocProvider.of<NetflixbarBloc>(context)
                                    .add(NetflixbarFriendsRequested()),
                            topTenTap: () =>
                                BlocProvider.of<NetflixbarBloc>(context)
                                    .add(NetflixbarTopRequested()),
                            quickLaughterTap: () => setState(() {
                              BlocProvider.of<NetflixbarBloc>(context)
                                  .add(NetflixbarQuickLaughtersRequested());
                            }),
                          );
                        },
                      ))
                  : null,
              body: _screens[_selectedIndex]),
        ),
      ),
      bottomNavigationBar: !AdaptiveLayout.isDesktop(context)
          ? BottomNavigationBar(
              items: _icons.entries
                  .map((entry) => BottomNavigationBarItem(
                        icon: Icon(entry.value),
                        label: entry.key,
                      ))
                  .toList(),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              selectedFontSize: 11,
              unselectedItemColor: Colors.grey,
              unselectedFontSize: 11,
              onTap: (index) => setState(() => _selectedIndex = index),
            )
          : null,
    );
  }
}
