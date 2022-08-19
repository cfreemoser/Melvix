import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netflix_gallery/cubits/color_generator/color_generator_cubit.dart';
import 'package:netflix_gallery/domain/content.dart';

class Previews extends StatelessWidget {
  final String title;
  final List<Content> contentList;
  final Function(Content) onTap;

  Previews(
      {Key? key,
      required this.title,
      required this.contentList,
      required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ColorGeneratorCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 165,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: contentList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final Content content = contentList[index];
                var img = Image.network(content.thumbnailCoverURL);

                BlocProvider.of<ColorGeneratorCubit>(context)
                    .generateColorFromImage(img);

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onTap(content),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: img.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        BlocBuilder<ColorGeneratorCubit, Color>(
                          builder: (context, color) {
                            return _circleContainer(color);
                          },
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              height: 60,
                              child: content.titleSvgURL == null
                                  ? Text(
                                      content.title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : FittedBox(
                                      child: SvgPicture.network(
                                        content.titleSvgURL!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _circleContainer(Color borderColor) {
    return Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 4,
            ),
            gradient: const LinearGradient(
                colors: [Colors.black87, Colors.black45, Colors.transparent],
                stops: [0.0, 0.25, 1.0],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)));
  }
}
