import "package:flutter/material.dart";

class CreatePagesBottomButton extends StatelessWidget {
  final Function createFunction;

  CreatePagesBottomButton({@required this.createFunction});

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
              onPressed: () async {
                await createFunction();
                Navigator.pop(context);
              },
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
