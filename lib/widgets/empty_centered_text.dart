import "package:flutter/material.dart";

class EmptyCenteredText extends StatelessWidget {
  final String content;

  EmptyCenteredText({required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
