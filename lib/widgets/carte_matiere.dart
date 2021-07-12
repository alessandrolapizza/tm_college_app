import "package:flutter/material.dart";

import "../models/matiere.dart";

class CarteMatiere extends StatelessWidget {
  final Matiere matiere;

  CarteMatiere(this.matiere);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        "/page_visualiser_matiere",
        arguments: matiere,
      ),
      child: Container(
        height: 90,
        width: double.infinity,
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatar(
                    backgroundColor: matiere.couleurMatiere,
                    child: Icon(
                      matiere.iconMatiere, // à construire (icon de matière)
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Column(
                    children: [
                      Text(
                        matiere.nom, // à construire (Nom de la matière)
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          "Salle : " +
                              matiere.salle, // à construire (Contenu du devoir)
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
