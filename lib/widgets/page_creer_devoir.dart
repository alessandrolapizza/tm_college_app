import "package:flutter/material.dart";

class PageCreerDevoir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveau devoir"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.05,
            child: Column(
              children: [
                Wrap(
                  runSpacing: 15,
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
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Contenu",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Date "),
                                Icon(Icons.date_range_rounded),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Importance "),
                                Icon(Icons.format_list_numbered_rtl_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("Annuler"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("Enregistrer"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
