import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/widgets/netflix_app_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/constants.dart';

class ContentList extends StatelessWidget {
  final bool highlighted;
  final List<Content> contentList;
  final String title;
  final Function(Content selectedContent) onContentSelected;

  const ContentList(
      {Key? key,
      this.highlighted = false,
      required this.contentList,
      required this.title,
      required this.onContentSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          height: highlighted ? 500 : 220,
          child: ListView.builder(
            itemCount: contentList.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (context, index) {
              final Content content = contentList[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onContentSelected(content),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: highlighted ? 400 : 200,
                    width: highlighted ? 260 : 130,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: FadeInImage.assetNetwork(
                          placeholder: Constants.melvix_cover,
                          image: content.headerImageURL,
                          fit: BoxFit.cover,
                        )),
                        content.titleSvgURL != null
                            ? Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  child: SvgPicture.network(
                                    content.titleSvgURL!,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
