import "package:flutter/material.dart";

class EditPagesBottomButton extends StatelessWidget {
  final Function editFunction;

  EditPagesBottomButton({@required this.editFunction});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
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
      ),
    );
  }
}
