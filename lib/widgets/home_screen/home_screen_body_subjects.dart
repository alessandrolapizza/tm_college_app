import "package:flutter/material.dart";
import "../../models/my_database.dart";
import "../empty_centered_text.dart";
import "../../models/subject.dart"; // Adjust the path as necessary
import "../subject_card.dart";

class HomeScreenBodySubjects extends StatelessWidget {
  final MyDatabase database;

  final Function onTapSubjectCardFunction;

  HomeScreenBodySubjects({
    required this.database,
    required this.onTapSubjectCardFunction,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.subjects(),
      builder: (_, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          var snapshotData = snapshot.data!;
          if (snapshotData.length == 0) {
            child = EmptyCenteredText(
                content:
                    "Aucune matière pour le moment.\nPour créer une matière, clique sur le +");
          } else {
            child = ReorderableListView.builder(
              //height: ,
              // color: Colors.red,

              onReorder: (oldIndex, newIndex) {
                print("Reordered");
              },
              itemCount: snapshotData.length,
              itemBuilder: (_, index) {
                return Column(
                  key: ValueKey(snapshotData[index].id),
                  children: [
                    SubjectCard(
                      subject: snapshotData[index],
                      onTapFunction: () => onTapSubjectCardFunction(
                          subject: snapshotData[index]),
                    ),
                    if (snapshotData.length != index + 1)
                      Divider(
                        thickness: 0.5,
                        height: 0,

                        //height: ,
                        // color: Colors.red,
                      ),
                  ],
                );
              },
            );
          }
        } else {
          child = Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}
