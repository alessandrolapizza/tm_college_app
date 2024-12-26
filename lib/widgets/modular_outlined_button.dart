import "package:flutter/material.dart";

class ModularOutlinedButton extends StatelessWidget {
  final Widget? child;

  final Function onPressedFunction;

  final missingObject;

  ModularOutlinedButton({
    required this.onPressedFunction,
    this.child,
    this.missingObject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      child: OutlinedButton(
        style: ButtonStyle(
          iconColor: missingObject != null
              ? missingObject
                  ? WidgetStateProperty.all(Theme.of(context).colorScheme.error)
                  : null
              : null,
          foregroundColor: missingObject != null
              ? missingObject
                  ? WidgetStateProperty.all(Theme.of(context).colorScheme.error)
                  : null
              : null,
          side: missingObject != null
              ? missingObject
                  ? WidgetStateProperty.all(
                      BorderSide(color: Theme.of(context).colorScheme.error),
                    )
                  : null
              : null,
        ),
        onPressed: () => onPressedFunction(),
        child: FittedBox(child: child),
      ),
    );
  }
}
