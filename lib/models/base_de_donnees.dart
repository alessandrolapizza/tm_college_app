import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class BaseDeDonnees {
  var baseDeDonneesMatieres;

  void defCheminMatieres() async {
    baseDeDonneesMatieres = openDatabase(
      join(await getDatabasesPath(), "matieres_basededonnees.db"),
      onCreate: (bD, version) {
        return bD.execute(
          "CREATE TABLE matieres(id INTEGER, nom TEXT, iconMatiere BLOB, couleurMatiere BLOB)",
        );
      },
      version: 1,
    );
  }
}
