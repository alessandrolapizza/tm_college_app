import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';

class VersionChangelogBloc extends StatelessWidget {
  final String changelogText;

  final String version;

  final PackageInfo packageInfo;

  VersionChangelogBloc({
    required this.changelogText,
    required this.version,
    required this.packageInfo,
  });

  @override
  Widget build(BuildContext context) {
    bool latest;
    if (version == packageInfo.version) {
      latest = true;
    } else {
      latest = false;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            latest ? "$version - Version actuelle" : version,
            style: TextStyle(
              fontWeight: latest ? FontWeight.w800 : FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              changelogText,
            ),
          ),
        ],
      ),
    );
  }
}
