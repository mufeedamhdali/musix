import 'package:flutter/material.dart';

class HeroBoxWidget extends StatelessWidget {
  const HeroBoxWidget(
      {required this.size, required this.link, required this.radius});

  final Size size;
  final String link;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(link),
            fit: BoxFit.fitHeight,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius)),
    );
  }
}
