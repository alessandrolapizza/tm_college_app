import "package:flutter/material.dart";

class CircleAvatarWithBorder extends StatelessWidget {
  final Color color;

  final IconData icon;

  CircleAvatarWithBorder({
    @required this.color,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[350],
      child: FractionallySizedBox(
        widthFactor: 0.98,
        heightFactor: 0.98,
        child: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
