import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netflix_gallery/domain/content.dart';

class Previews extends StatelessWidget {
  final String title;
  final List<Content> contentList;

  const Previews({Key? key, required this.title, required this.contentList})
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
        Container(
          height: 165,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            itemCount: contentList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Content content = contentList[index];
              return GestureDetector(
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
                        //TODO generate from image
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        image: DecorationImage(
                          image: AssetImage(content.headerImageURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Colors.black87,
                                Colors.black45,
                                Colors.transparent
                              ],
                              stops: [
                                0.0,
                                0.25,
                                1.0
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                    ),
                    const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          height: 60,
                          child: Text(
                            "A supoer title",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
