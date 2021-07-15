import "package:flutter/material.dart";
import "package:intl/intl.dart";

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
  DateTime _dateSelected;
  int _prioritySelected = 0;

  Future<void> _selectPriority() async {
    _prioritySelected = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
            child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text("test"),
                );
              },
            ),
          ],
        ));
      },
    );
  }

  Future<void> _selectDate() async {
    _dateSelected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020), //à construire plus tard.
      lastDate: DateTime(2050), //à construire plus tard.
    );

    setState(() => _dateSelected);
  }

  Future<void> _selectSubject() async {
    _subjectSelected = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
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
                stops: [0.0, 0.02, 0.98, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: FutureBuilder(
              future: _bD.matieres(),
              builder: (_, snapshot) {
                var children;
                if (snapshot.hasData) {
                  children = SingleChildScrollView(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        print(index);
                        print(snapshot.data.length);
                        return index != snapshot.data.length
                            ? ListTile(
                                onTap: () => Navigator.pop(
                                    context, snapshot.data[index]),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      snapshot.data[index].couleurMatiere,
                                  child: Icon(
                                    snapshot.data[index].iconMatiere,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(snapshot.data[index].nom),
                              )
                            : ListTile(
                                onTap: () => Navigator.pop(context),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Matiere.noSubject.couleurMatiere,
                                  child: Icon(
                                    Matiere.noSubject.iconMatiere,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(Matiere.noSubject.nom),
                              );
                      },
                    ),
                  );
                } else {
                  children = Center(child: CircularProgressIndicator());
                }
                return children;
              },
            ),
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
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: OutlinedButton(
                            onPressed: () => _selectDate(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _dateSelected == null
                                  ? [
                                      Text("Date "),
                                      Icon(
                                        Icons.date_range_rounded,
                                        size: 20,
                                      ),
                                    ]
                                  : [
                                      Text(
                                        DateFormat("EEE d MMMM")
                                            .format(_dateSelected),
                                      )
                                    ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: OutlinedButton(
                            onPressed: () => _selectPriority(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Importance "),
                                Icon(
                                  Icons.format_list_numbered_rtl_rounded,
                                  size: 20,
                                ),
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
