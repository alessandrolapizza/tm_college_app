import "package:flutter/material.dart";

class EditScreensBottomButton extends StatelessWidget {
  final Function editFunction;

  EditScreensBottomButton({@required this.editFunction});

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
          ElevatedButton(
            onPressed: () => editFunction(),
            child: Text("Enregistrer"),
          ),
        ],
      ),
    );
  }
}
