import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/circle_avatar_with_border.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';

import "../models/devoir.dart";

class CarteDevoir extends StatelessWidget {
  final Devoir devoir;

  final Function onTapFunction;

  final Widget actionButton;

  CarteDevoir({
    @required this.devoir,
    this.onTapFunction,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction != null ? onTapFunction : null,
      child: Container(
        height: 90,
        width: double.infinity,
        child: Card(
          elevation: 0.5,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  color: Devoir.priorityColorMap.values.toList()[
                      devoir.priority], // à construire (couleur de priorité)
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatarWithBorder(
                    color: devoir.subject.couleurMatiere,
                    icon: devoir.subject.iconMatiere,
                  ),
                ),
              ),
              Expanded(
                flex: 13,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Column(
                    children: [
                      Text(
                        devoir.subject.nom, // à construire (Nom de la matière)
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          devoir.content, // à construire (Contenu du devoir)
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: actionButton,
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
