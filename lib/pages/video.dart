import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/cubits/video/video_cubit.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/navigation/video_args.dart';
import 'package:netflix_gallery/widgets/player.dart';

class Video extends StatelessWidget {
  const Video({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<VideoCubit>(
        create: (_) => VideoCubit(),
        child: BlocBuilder<VideoCubit, Content?>(
          builder: (context, state) {
            log(state.toString());
            if (state != null) {
              return Player(
                content: state,
              );
            }

            var model = ModalRoute.of(context);
            if (model != null && model.settings.arguments != null) {
              final args = model.settings.arguments as VideoArgs;
              Future<void>.delayed(const Duration(milliseconds: 50)).then(
                  (value) => BlocProvider.of<VideoCubit>(context)
                      .setContent(args.content));
            }

            return Container(color: Colors.black);
          },
        ),
      ),
    );
  }
}
