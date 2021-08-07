import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/create_pages_bottom_buttons.dart';
import 'package:tm_college_app/widgets/create_subject_form.dart';
import 'package:tm_college_app/widgets/create_subject_select_icon_button.dart';
import 'package:tm_college_app/widgets/create_subject_select_color_button.dart';

class CreateSubjectBody extends StatelessWidget {
  final Function selectIconFunction;

  final IconData selectedIcon;

  final Function selectColor;

  final Color selectedColor;

  final Function createSubjectFunction;

  final TextEditingController subjectNameController;

  final TextEditingController subjectRoomNumberController;

  CreateSubjectBody({
    @required this.selectIconFunction,
    @required this.selectedIcon,
    @required this.selectColor,
    @required this.selectedColor,
    @required this.createSubjectFunction,
    @required this.subjectNameController,
    @required this.subjectRoomNumberController,
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
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              Column(
                children: [
                  CreateSubjectForm(
                    subjectNameController: subjectNameController,
                    subjectRoomNumberController: subjectRoomNumberController,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: CreateSubjectSelectIconButton(
                          selectIconFunction: selectIconFunction,
                          selectedIcon: selectedIcon,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: CreateSubjectSelectColorButton(
                          selectColor: selectColor,
                          selectedColor: selectedColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              CreatePagesBottomButton(createFunction: createSubjectFunction),
            ],
          ),
        ),
      ),
    );
  }
}
