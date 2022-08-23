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
          : Center(
              child: Card(
                margin: EdgeInsets.all(0),
                color: Colors.grey[50],
                child: Container(
                  child: Center(child: header),
                  height: 30,
                ),
              ),
            ),
      content: content,
    );
  }
}
