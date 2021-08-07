import "package:flutter/material.dart";

class CreateHomeworkForm extends StatelessWidget {
  final TextEditingController homeworkContentController;

  CreateHomeworkForm({@required this.homeworkContentController});

  final GlobalKey<FormState> createHomeworkFormKey = GlobalKey();

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
