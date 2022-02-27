import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/cubits/app_bar/app_bar_cubit.dart';
import 'package:netflix_gallery/pages/home.dart';
import 'package:netflix_gallery/widgets/adaptive_layout.dart';

class NavScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NaveScreenState();
}

class _NaveScreenState extends State<NavScreen> {
  final List<Widget> _screens = const [
    Home(
      key: PageStorageKey('homeScreen'),
    ),
    Scaffold(),
    Scaffold(),
    Scaffold(),
    Scaffold()
  ];

  final Map<String, IconData> _icons = const {
    'home': Icons.home,
    'search': Icons.search,
    'Coming Soon': Icons.queue_play_next,
    'Downloads': Icons.file_download,
    'More': Icons.menu
  };

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider<AppBarCubit>(
        create: (_) => AppBarCubit(),
        child: _screens[_selectedIndex],
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
