import "package:flutter/material.dart";

class EditScreensBottomButton extends StatelessWidget {
  final Function editFunction;

  final bool? editScreen;

  EditScreensBottomButton({
    required this.editFunction,
    this.editScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
          FilledButton(
            onPressed: () => editFunction(),
            child: Text(editScreen == null
                ? "Ajouter"
                : editScreen!
                    ? "Modifier"
                    : "Ajouter"),
          ),
        ],
      ),
    );
  }
}
