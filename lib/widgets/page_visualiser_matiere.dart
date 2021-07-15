import "package:flutter/material.dart";

import "../models/matiere.dart";

class PageVisualiserMatiere extends StatefulWidget {
  @override
  _PageVisualiserMatiereState createState() => _PageVisualiserMatiereState();
}

class _PageVisualiserMatiereState extends State<PageVisualiserMatiere> {
  @override
  Widget build(BuildContext context) {
  final matiere = ModalRoute.of(context).settings.arguments as Matiere;
    return Scaffold(
      appBar: AppBar(
        title: Text(matiere.nom),
      ),
    );
  }
}


//à continuer