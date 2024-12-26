import 'package:flutter/material.dart';
import '../models/subject.dart'; // Assurez-vous que le chemin est correct

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTapFunction;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accès au thème actuel pour les couleurs
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      // Action à effectuer lors du tap sur la carte
      onTap: onTapFunction,
      // Forme de l'élément pour arrondir les coins
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
      // Couleur de fond de la carte
      //tileColor: colorScheme.onInverseSurface,
      // Espacement interne de l'élément
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Élément de début (leading)
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: subject.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: ThemeMode.system == ThemeMode.dark
                ? const Color(0xFF000000)
                : Colors.grey[350]!,
          ),
        ),
        child: Icon(
          subject.icon,
          color: ThemeData.estimateBrightnessForColor(subject.color!) ==
                  Brightness.dark
              ? Colors.white
              : Colors.black,
          size: 30,
        ),
      ),
      // Titre de la carte
      title: Text(
        subject.name!,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          //color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
      // Sous-titre conditionnel (affiché si la salle est renseignée)
      subtitle: subject.room!.isNotEmpty
          ? Text(
              "Salle : ${subject.room}",
              style: TextStyle(
                // color: colorScheme.onInverseSurface,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      // Élément de fin (trailing) optionnel
      // trailing: Icon(
      //   Icons.arrow_forward_ios,
      //   size: 16,
      // ),
    );
  }
}
