import "package:flutter/material.dart";

class CreateSubjectForm extends StatelessWidget {
  final TextEditingController subjectNameController;

  final TextEditingController subjectRoomNumberController;

  CreateSubjectForm({
    @required this.subjectNameController,
    @required this.subjectRoomNumberController,
  });

  final GlobalKey<FormState> createSubjectFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: createSubjectFormKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.trim() == "") {
                return "Un nom de matière doit être fourni";
              }
              return null;
            },
            controller: subjectNameController,
            autofocus: true,
            maxLength: 20,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            decoration: InputDecoration(
              icon: Icon(Icons.text_fields_rounded),
              labelText: "Nom de la matière",
              border: OutlineInputBorder(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.trim() == "") {
                return "Un nunméro de salle doit être fourni";
              }
              return null;
            },
            controller: subjectRoomNumberController,
            maxLength: 5,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.format_list_numbered_rtl_rounded),
              labelText: "Numéro de salle",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
