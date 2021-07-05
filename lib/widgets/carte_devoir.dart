import "package:flutter/material.dart";

import "../models/devoir.dart";

class CarteDevoir extends StatelessWidget {
  final listeCouleurImportance = [
    Colors.white,
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
  ];

  final Devoir devoir;

  CarteDevoir(this.devoir);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 90,
        width: double.infinity,
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  color: listeCouleurImportance[
                      devoir.importance], // à construire (couleur de priorité)
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: devoir.matiere
                        .couleurMatiere, //à construire (couleur de matière)
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.1,
                    ),
                  ),
                  child: Icon(
                    devoir
                        .matiere.iconMatiere, // à construire (icon de matière)
                    color: Colors.white,
                    size: 40,
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
                        devoir.matiere.nom, // à construire (Nom de la matière)
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          devoir.contenu, // à construire (Contenu du devoir)
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
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.check),
                    color: Colors.green,
                    splashRadius: 20,
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
