import "package:flutter/material.dart";

class EditHomeworkForm extends StatelessWidget {
  final TextEditingController homeworkContentController;

  final GlobalKey<FormState> createHomeworkFormKey;

  EditHomeworkForm({
    @required this.homeworkContentController,
    @required this.createHomeworkFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: createHomeworkFormKey,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.trim() == "") {
            return "Un contenu doit être fourni";
          }
          return null;
        },
        maxLength: 1000,
        controller: homeworkContentController,
        keyboardType: TextInputType.multiline,
        autofocus: true,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Contenu",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
