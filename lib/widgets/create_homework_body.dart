import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/create_homework_form.dart';
import 'package:tm_college_app/widgets/create_homework_select_date_button.dart';
import 'package:tm_college_app/widgets/create_homework_select_priority_button.dart';
import 'package:tm_college_app/widgets/create_homework_select_subject_button.dart';
import 'package:tm_college_app/widgets/create_pages_bottom_buttons.dart';
import "../models/matiere.dart";

class CreateHomeworkBody extends StatelessWidget {
  final Function selectSubjectFunction;

  final Matiere selectedSubject;

  final TextEditingController homeworkContentController;

  final Function selectDateFunction;

  final DateTime selectedDate;

  final Function selectPriorityFunction;

  final int selectedPriority;

  final Function createHomeworkFunction;

  final GlobalKey<FormState> createHomeworkFormKey;

  final bool dateMissing;

  CreateHomeworkBody({
    @required this.selectSubjectFunction,
    @required this.selectedSubject,
    @required this.homeworkContentController,
    @required this.selectDateFunction,
    @required this.selectedDate,
    @required this.selectPriorityFunction,
    @required this.selectedPriority,
    @required this.createHomeworkFunction,
    @required this.createHomeworkFormKey,
    @required this.dateMissing,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.05,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              Column(
                children: [
                  CreateHomeworkSelectSubjectButton(
                    selectSubjectFunction: selectSubjectFunction,
                    selectedSubject: selectedSubject,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  CreateHomeworkForm(
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
                        child: CreateHomeworkSelectDateButton(
                          selectDateFunction: selectDateFunction,
                          selectedDate: selectedDate,
                          dateMissing: dateMissing,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: CreateHomeworkSelectPriorityButton(
                          selectPriorityFunction: selectPriorityFunction,
                          selectedPriority: selectedPriority,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CreatePagesBottomButton(createFunction: createHomeworkFunction),
            ],
          ),
        ),
      ),
    );
  }
}
