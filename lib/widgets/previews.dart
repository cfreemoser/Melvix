import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:palette_generator/palette_generator.dart';

class Previews extends StatelessWidget {
  final String title;
  final List<Content> contentList;
  PaletteGenerator? paletteGenerator;

  Previews({Key? key, required this.title, required this.contentList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
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
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => log("message"),
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
                            image: NetworkImage(content.headerImageURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      FutureBuilder<PaletteGenerator?>(
                          future: _updatePaletteGenerator(content),
                          builder: (BuildContext context,
                              AsyncSnapshot<PaletteGenerator?> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return _circleContainer(Colors.white);
                              default:
                                if (snapshot.hasError) {
                                  return _circleContainer(Colors.orange);
                                }
                                var color = snapshot.data?.dominantColor?.color;
                                if (color != null) {
                                  return _circleContainer(color);
                                }
                                return _circleContainer(Colors.red);
                            }
                          }),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SizedBox(
                            height: 60,
                            child: content.titleSvgURL == null
                                ? Text(
                                    content.title,
                                    style: const TextStyle(color: Colors.white),
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
    );
  }

  Future<PaletteGenerator?> _updatePaletteGenerator(Content content) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(content.headerImageURL).image,
    );
    return paletteGenerator;
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
