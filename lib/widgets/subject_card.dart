import "package:flutter/material.dart";
import "./circle_avatar_with_border.dart";
import "../models/subject.dart";

class SubjectCard extends StatelessWidget {
  final Subject subject;

  final Function onTapFunction;

  SubjectCard({
    @required this.subject,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction != null ? onTapFunction : null,
      child: Container(
        height: 90,
        width: double.infinity,
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatarWithBorder(
                    color: subject.color,
                    icon: subject.icon,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Column(
                    children: [
                      Text(
                        subject.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          "Salle : " +
                              subject.room, // à construire (Contenu du devoir)
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
      ),
    );
  }
}
