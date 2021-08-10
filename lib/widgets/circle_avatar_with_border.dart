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
          child: FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.6,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                icon,
                color: Colors.white,
                size: 1000,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
