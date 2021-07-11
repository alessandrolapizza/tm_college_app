import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class PageCreerDevoir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveau devoir"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Matière "),
                  Icon(Icons.school_rounded),
                ],
              ),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text("Date "),
                      Icon(Icons.date_range_rounded),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text("Importance "),
                      Icon(Icons.format_list_numbered_rtl_rounded),
                    ],
                  ),
                ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Contenu",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
