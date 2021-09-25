import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/edit_screens_bottom_buttons.dart';
import 'package:tm_college_app/widgets/edit_subject_form.dart';
import 'package:tm_college_app/widgets/edit_subject_select_icon_button.dart';
import 'package:tm_college_app/widgets/edit_subject_select_color_button.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';

class EditSubjectBody extends StatelessWidget {
  final Function selectIconFunction;

  final IconData selectedIcon;

  final Function selectColor;

  final Color selectedColor;

  final Function createSubjectFunction;

  final TextEditingController subjectNameController;

  final TextEditingController subjectRoomNumberController;

  final GlobalKey<FormState> createSubjectFormKey;

  final bool iconMissing;

  final bool colorMissing;

  EditSubjectBody({
    @required this.selectIconFunction,
    @required this.selectedIcon,
    @required this.selectColor,
    @required this.selectedColor,
    @required this.createSubjectFunction,
    @required this.subjectNameController,
    @required this.subjectRoomNumberController,
    @required this.createSubjectFormKey,
    @required this.iconMissing,
    @required this.colorMissing,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        EditSubjectForm(
                          subjectNameController: subjectNameController,
                          subjectRoomNumberController:
                              subjectRoomNumberController,
                          createSubjectFormKey: createSubjectFormKey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: EditSubjectSelectIconButton(
                                selectIconFunction: selectIconFunction,
                                selectedIcon: selectedIcon,
                                iconMissing: iconMissing,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: EditSubjectSelectColorButton(
                                selectColor: selectColor,
                                selectedColor: selectedColor,
                                colorMissing: colorMissing,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              EditScreensBottomButton(editFunction: createSubjectFunction),
            ],
          ),
        ),
      ),
    );
  }
}
