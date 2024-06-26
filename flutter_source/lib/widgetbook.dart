import 'package:flutter/material.dart';
import 'package:light_house/src/utils/app_themes.dart';
import 'package:light_house/widgetbook.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() async {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      appBuilder: (_, child) => child,
      addons: [
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: generateThemeData(seedColor: Colors.white, brightness: Brightness.light),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: generateThemeData(seedColor: Colors.black, brightness: Brightness.dark),
            ),
          ],
          themeBuilder: (context, theme, child) {
            return Theme(
              data: theme,
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!,
                child: child,
              ),
            );
          },
        ),
      ],
    );
  }
}
