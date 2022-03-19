import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';

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
              return GestureDetector(
                onTap: () => onContentSelected(content),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: highlighted ? 400 : 200,
                  width: highlighted ? 200 : 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(content.headerImageURL),
                      fit: BoxFit.cover,
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
