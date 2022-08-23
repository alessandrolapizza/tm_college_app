import "package:flutter/material.dart";

class EditSubjectForm extends StatelessWidget {
  final TextEditingController subjectNameController;

  final TextEditingController subjectRoomNumberController;

  final GlobalKey<FormState> createSubjectFormKey;

  EditSubjectForm({
    @required this.subjectNameController,
    @required this.subjectRoomNumberController,
    @required this.createSubjectFormKey,
  });

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
            maxLength: 30,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            decoration: InputDecoration(
              icon: Icon(Icons.text_fields_rounded),
              labelText: "Nom",
              border: OutlineInputBorder(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
          ),
          TextFormField(
            controller: subjectRoomNumberController,
            maxLength: 16,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.meeting_room_rounded),
              labelText: "Numéro de salle (facultatif)",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
