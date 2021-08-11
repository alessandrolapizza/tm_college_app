import "package:flutter/material.dart";

class ModularOutlinedButton extends StatelessWidget {
  final Widget child;

  final Function onPressedFunction;

  final missingObject;

  ModularOutlinedButton({
    this.child,
    this.onPressedFunction,
    this.missingObject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      child: OutlinedButton(
        style: ButtonStyle(
          foregroundColor: missingObject != null
              ? missingObject
                  ? MaterialStateProperty.all(Colors.red)
                  : null
              : null,
          side: missingObject != null
              ? missingObject
                  ? MaterialStateProperty.all(
                      BorderSide(color: Colors.red),
                    )
                  : null
              : null,
        ),
        onPressed: () => onPressedFunction(),
        child: child,
      ),
    );
  }
}
