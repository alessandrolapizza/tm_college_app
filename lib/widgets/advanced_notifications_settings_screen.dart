import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/advanced_notifications_settings_body.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';

class AdvancedNotificationsSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        backArrow: true,
        centerTitle: true,
        hideSettingsButton: true,
        title: Text("Notifications avancées"),
      ),
      body: AdvancedNotificationsSettingsBody(),
    );
  }
}
