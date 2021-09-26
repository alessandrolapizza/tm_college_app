import "package:flutter/material.dart";
import "package:sticky_headers/sticky_headers.dart";

class ModularStickyHeader extends StatelessWidget {
  final Widget header;

  final Widget content;

  final bool show;

  ModularStickyHeader({
    @required this.content,
    @required this.header,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: !show
          ? Container()
          : Container(
              height: 30,
              width: double.infinity,
              child: Material(
                elevation: 1.5,
                child: Container(
                  color: Colors.grey[50],
                  child: Center(
                    child: header,
                  ),
                ),
              ),
            ),
      content: content,
    );
  }
}
