import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/quick_content_bloc.dart';
import 'package:netflix_gallery/widgets/loading_quick_content.dart';
import 'package:netflix_gallery/widgets/quick_content_carousel.dart';

class QuickContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<QuickContentBloc>(context)
        .add(const QuickContentRequested());

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<QuickContentBloc, QuickContentState>(
            builder: (context, state) {
              if (state is QuickContentLoaded) {
                return QuickContentCarousel(
                  quickContents: state.quickContents,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );
              }
              return const LoadingQuickContent();
            },
          );
        },
      ),
    );
  }
}
