import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class TopContentList extends StatelessWidget {
  final List<Content> contentList;
  final String title;
  final Function(Content selectedContent) onContentSelected;

  const TopContentList(
      {Key? key,
      required this.contentList,
      required this.title,
      required this.onContentSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 32, left: 60),
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
          height: 220,
          child: ListView.builder(
            itemCount: contentList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Content content = contentList[index];
              return Container(
                margin: const EdgeInsets.only(right: 16),
                width: 240,
                height: 200,
                child: Stack(
                  children: [
                    SizedBox(
                        width: 150,
                        height: double.infinity,
                        child: BorderBoxedText(
                          hight: 100,
                          width: 70,
                          text: (index + 1).toString(),
                        )),
                    Positioned(
                      left: 95,
                      child: ContentCard(
                          onContentSelected: onContentSelected,
                          content: content),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class ContentCard extends StatefulWidget {
  const ContentCard({
    Key? key,
    required this.onContentSelected,
    required this.content,
  }) : super(key: key);

  final Function(Content selectedContent) onContentSelected;
  final Content content;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  double elevationValue = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onContentSelected(widget.content),
        child: Container(
          height: 220,
          width: 140,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.content.headerImageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class BorderBoxedText extends StatelessWidget {
  final double width;
  final double hight;
  final String text;
  final double scaleFactor = 1.45;

  const BorderBoxedText(
      {Key? key, required this.width, required this.hight, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: hight,
      child: Stack(children: [
        Positioned.fill(
          child: Transform.scale(
            scale: scaleFactor,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 70,
                  fontFamily: "NetflixSans",
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Constants.netflix_grey,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Transform.scale(
            scale: scaleFactor,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 70,
                fontFamily: "NetflixSans",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )),
      ]),
    );
  }
}
