import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../models/subject.dart";
import "./circle_avatar_with_border.dart";
import "./edit_homework_body.dart";
import "./fade_gradient.dart";
import "./modular_app_bar.dart";
import "./theme_controller.dart";

class EditHomeworkScreen extends StatefulWidget {
  final MyDatabase database;

  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  EditHomeworkScreen({
    required this.database,
    required this.notifications,
    required this.sharedPreferences,
  });

  @override
  _EditHomeworkScreenState createState() => _EditHomeworkScreenState();
}

class _EditHomeworkScreenState extends State<EditHomeworkScreen> {
  late TextEditingController _homeworkContentController; //Pas sur du late (?)

  final GlobalKey<FormState> _createHomeworkFormKey = GlobalKey();

  int _selectedPriority = 0;

  late Subject _selectedSubject;

  DateTime? _selectedDate;

  bool _dateMissing = false;

  setSelectedDate(Homework homework) {
    if (widget.sharedPreferences.getString("selectedDayCalendar") != null) {
      _selectedDate = DateTime.parse(
          widget.sharedPreferences.getString("selectedDayCalendar")!);
    }
    _selectedDate =
        _selectedDate ?? homework.dueDate; //Vrm pas sur du moov. (?)
  }

  Future<void> _selectSubject(BuildContext ctx) async {
    Subject subject = await showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return SafeArea(
              child: FadeGradient(
                child: FutureBuilder(
                  future: widget.database.subjects(),
                  builder: (_, snapshot) {
                    var children;
                    if (snapshot.hasData) {
                      var snapshotData = snapshot.data! as List<Subject>;
                      children = SingleChildScrollView(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshotData.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            return index != snapshotData.length
                                ? ListTile(
                                    onTap: () => Navigator.pop(
                                        context, snapshotData[index]),
                                    leading: CircleAvatarWithBorder(
                                      color: snapshotData[index].color,
                                      icon: snapshotData[index].icon,
                                    ),
                                    title: Text(snapshotData[index].name!),
                                  )
                                : ListTile(
                                    title: Text(Subject.noSubject.name!),
                                    onTap: () => Navigator.pop(
                                        context, Subject.noSubject),
                                    leading: CircleAvatarWithBorder(
                                      color: Subject.noSubject.color,
                                      icon: Subject.noSubject.icon,
                                    ),
                                  );
                          },
                        ),
                      );
                    } else {
                      children = Center(child: CircularProgressIndicator());
                    }
                    return children;
                  },
                ),
              ),
            );
          },
        ) ??
        Subject.noSubject;

    if (subject != null) {
      setState(() => _selectedSubject = subject);
    }
  }

  // Future<void> _selectDate() async {
  //   DateTime date = await showDatePicker(
  //     confirmText: "OK",
  //     cancelText: "Annuler",
  //     context: context,
  //     initialDate: _selectedDate == null
  //         ? DateTime.now().isAfter(
  //             DateTime.parse(
  //               widget.sharedPreferences.getString("firstTermBeginingDate"),
  //             ),
  //           )
  //             ? DateTime.now().isBefore(
  //                 DateTime.parse(
  //                   widget.sharedPreferences.getString("secondTermEndingDate"),
  //                 ),
  //               )
  //                 ? DateTime.now()
  //                 : DateTime.parse(
  //                     widget.sharedPreferences
  //                         .getString("secondTermEndingDate"),
  //                   )
  //             : DateTime.parse(
  //                 widget.sharedPreferences.getString("firstTermBeginingDate"),
  //               )
  //         : _selectedDate,
  //     firstDate: DateTime.parse(
  //       widget.sharedPreferences.getString("firstTermBeginingDate"),
  //     ),
  //     lastDate: DateTime.parse(
  //       widget.sharedPreferences.getString("secondTermEndingDate"),
  //     ),
  //     builder: (BuildContext context, Widget child) {
  //       return ThemeController(
  //         child: child,
  //         color: _selectedSubject.color,
  //       );
  //     },
  //   );

  Future<void> _selectDate() async {
    DateTime? date = await showDatePicker(
      // helpText: "Sélectionnser une date",
      confirmText: "OK",
      cancelText: "Annuler",
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.parse(
        widget.sharedPreferences.getString("firstTermBeginingDate") ??
            DateTime.now().toString(),
      ),
      lastDate: DateTime.parse(
        widget.sharedPreferences.getString("secondTermEndingDate") ??
            DateTime.now().toString(),
      ),
      builder: (BuildContext context, Widget? child) {
        return ThemeController(
          child: child!,
          color: _selectedSubject.color,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectPriority(BuildContext ctx) async {
    int priority = await showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return SafeArea(
              child: FadeGradient(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (_, index) {
                      return ListTile(
                        onTap: () => Navigator.pop(context, index),
                        leading: CircleColor(
                          color:
                              Homework.priorityColorMap.values.toList()[index],
                          circleSize: 40,
                        ),
                        title: Text(
                          Homework.priorityColorMap.keys.toList()[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ) ??
        1;
    if (priority != null) {
      setState(() => _selectedPriority = priority);
    }
  }

  Future<void> _editHomework(Homework homework) async {
    bool created = false;
    Homework? newHomework;
    if (_createHomeworkFormKey.currentState!.validate() &&
        _selectedDate != null) {
      newHomework = Homework(
        content: _homeworkContentController.text,
        dueDate: _selectedDate,
        subjectId: _selectedSubject.id,
        priority: _selectedPriority,
        done: false,
        subject: _selectedSubject,
        id: homework == null ? null : homework.id,
        notificationsIds: await widget.notifications.scheduleNotifications(
          homeworkDueDate: _selectedDate,
          homeworkPriority: _selectedPriority,
          homeworkSubjectName: _selectedSubject.name,
          oldNotifications: homework == null ? null : homework.notificationsIds,
        ),
      );
      homework == null
          ? await widget.database.insertHomework(
              newHomework,
            )
          : await widget.database.updateHomework(
              newHomework,
            );
      created = true;
    } else {
      if (_selectedDate == null) {
        _dateMissing = true;
      } else {
        _dateMissing = false;
      }
      setState(() => _dateMissing);
      created = false;
    }
    if (created) {
      if (newHomework != null) {
        Navigator.pop(context, [newHomework]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final Homework homework = arguments[0] ??
        Homework(
            content: "",
            done: false,
            dueDate: DateTime.now(),
            priority: 0,
            subject: Subject.noSubject,
            subjectId: "",
            id: "");
    final bool newHomework = arguments[1];
    _selectedPriority = homework.priority!;
    _homeworkContentController = TextEditingController(text: homework.content);
    _selectedSubject = homework.subject!;
    setSelectedDate(homework);
    return ThemeController(
      color: _selectedSubject.color,
      child: Scaffold(
        appBar: ModularAppBar(
          hideSettingsButton: true,
          backArrow: true,
          title: Text(newHomework ? "Nouveau devoir" : "Modifier devoir"),
          centerTitle: true,
        ),
        body: EditHomeworkBody(
          selectSubjectFunction: _selectSubject,
          selectedSubject: _selectedSubject,
          homeworkContentController: _homeworkContentController,
          selectDateFunction: _selectDate,
          selectedDate: _selectedDate,
          selectPriorityFunction: _selectPriority,
          selectedPriority: _selectedPriority,
          editHomeworkFunction: () => _editHomework(homework),
          createHomeworkFormKey: _createHomeworkFormKey,
          dateMissing: _dateMissing,
        ),
      ),
    );
  }

  //   Widget build(BuildContext context) {
  //   final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
  //   final Homework homework = arguments[0];
  //   final bool newHomework = arguments[1];
  //   _selectedPriority = _selectedPriority != null
  //       ? _selectedPriority
  //       : homework == null
  //           ? 0
  //           : homework.priority;
  //   _homeworkContentController = _homeworkContentController != null
  //       ? _homeworkContentController
  //       : homework == null
  //           ? TextEditingController()
  //           : TextEditingController(text: homework.content);
  //   _selectedSubject = _selectedSubject != null
  //       ? _selectedSubject
  //       : homework == null
  //           ? Subject.noSubject
  //           : homework.subject;
  //   setSelectedDate(homework);
  //   return ThemeController(
  //     color: _selectedSubject.color,
  //     child: Scaffold(
  //       appBar: ModularAppBar(
  //         hideSettingsButton: true,
  //         backArrow: true,
  //         title: Text(newHomework ? "Nouveau devoir" : "Modifier devoir"),
  //         centerTitle: true,
  //       ),
  //       body: EditHomeworkBody(
  //         selectSubjectFunction: _selectSubject,
  //         selectedSubject: _selectedSubject,
  //         homeworkContentController: _homeworkContentController,
  //         selectDateFunction: _selectDate,
  //         selectedDate: _selectedDate,
  //         selectPriorityFunction: _selectPriority,
  //         selectedPriority: _selectedPriority,
  //         editHomeworkFunction: () => _editHomework(homework),
  //         createHomeworkFormKey: _createHomeworkFormKey,
  //         dateMissing: _dateMissing,
  //       ),
  //     ),
  //   );
  // }
}
