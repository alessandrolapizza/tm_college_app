import "package:flutter/material.dart";
import "../models/subject.dart";
import "./edit_screens_bottom_buttons.dart";
import "./edit_homework_form.dart";
import "./edit_homework_select_date_button.dart";
import "./edit_homework_select_priority_button.dart";
import "./edit_homework_select_subject_button.dart";
import "./fade_gradient.dart";

class EditHomeworkBody extends StatelessWidget {
  final Function selectSubjectFunction;

  final Subject? selectedSubject;

  final TextEditingController? homeworkContentController;

  final Function selectDateFunction;

  final DateTime? selectedDate;

  final Function selectPriorityFunction;

  final int? selectedPriority;

  final Function editHomeworkFunction;

  final GlobalKey<FormState> createHomeworkFormKey;

  final bool dateMissing;

  EditHomeworkBody({
    required this.selectSubjectFunction,
    required this.selectedSubject,
    required this.homeworkContentController,
    required this.selectDateFunction,
    required this.selectedDate,
    required this.selectPriorityFunction,
    required this.selectedPriority,
    required this.editHomeworkFunction,
    required this.createHomeworkFormKey,
    required this.dateMissing,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.05,
          child: Column(
            children: [
              Expanded(
                child: FadeGradient(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        EditHomeworkSelectSubjectButton(
                          selectSubjectFunction: selectSubjectFunction,
                          selectedSubject: selectedSubject,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                        ),
                        EditHomeworkForm(
                          homeworkContentController: homeworkContentController,
                          createHomeworkFormKey: createHomeworkFormKey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: EditHomeworkSelectDateButton(
                                selectDateFunction: selectDateFunction,
                                selectedDate: selectedDate,
                                dateMissing: dateMissing,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: EditHomeworkSelectPriorityButton(
                                selectPriorityFunction: selectPriorityFunction,
                                selectedPriority: selectedPriority,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              EditScreensBottomButton(editFunction: editHomeworkFunction),
            ],
          ),
        ),
      ),
    );
  }
}
