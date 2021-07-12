import "package:flutter/material.dart";

import "../models/matiere.dart";
import "../models/base_de_donnees.dart";

class PageCreerDevoir extends StatefulWidget {
  final BaseDeDonnees bD;

  PageCreerDevoir(this.bD);
  @override
  _PageCreerDevoirState createState() => _PageCreerDevoirState(bD);
}

class _PageCreerDevoirState extends State<PageCreerDevoir> {
  BaseDeDonnees _bD;

  _PageCreerDevoirState(this._bD);

  Matiere _subjectSelected;

  Future<void> _selectSubject() async {
    _subjectSelected = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black,
                      ],
                      stops: [
                        0.0,
                        0.02,
                        0.98,
                        1.0
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: FutureBuilder(
                    future: _bD.matieres(),
                    builder: (_, snapshot) {
                      var children;
                      if (snapshot.hasData) {
                        children = ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              onTap: () =>
                                  Navigator.pop(context, snapshot.data[index]),
                              leading: CircleAvatar(
                                backgroundColor:
                                    snapshot.data[index].couleurMatiere,
                                child: Icon(
                                  snapshot.data[index].iconMatiere,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(snapshot.data[index].nom),
                            );
                          },
                        );
                      } else {
                        children = Center(child: CircularProgressIndicator());
                      }
                      return children;
                    },
                  ),
                ),
              ),
              ListTile(
                onTap: () => Navigator.pop(context, Matiere.noSubject),
                leading: CircleAvatar(
                  backgroundColor: Matiere.noSubject.couleurMatiere,
                  child: Icon(
                    Matiere.noSubject.iconMatiere,
                    color: Colors.white,
                  ),
                ),
                title: Text(Matiere.noSubject.nom),
              )
            ],
          ),
        );
      },
    );

    if (_subjectSelected == Matiere.noSubject) {
      _subjectSelected = null;
    }

    setState(() => _subjectSelected);
  }

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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                Wrap(
                  runSpacing: 15,
                  children: [
                    OutlinedButton(
                      onPressed: () => _selectSubject(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _subjectSelected == null
                            ? [
                                Text("Matière "),
                                Icon(
                                  Icons.school_rounded,
                                  size: 20,
                                ),
                              ]
                            : [
                                CircleAvatar(
                                  backgroundColor:
                                      _subjectSelected.couleurMatiere,
                                  child: Icon(
                                    _subjectSelected.iconMatiere,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  radius: 15,
                                ),
                                Text(" " + _subjectSelected.nom),
                              ],
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
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
                          onPressed: () => Navigator.pop(context),
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
