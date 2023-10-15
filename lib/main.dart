import 'package:flutter/material.dart';
import 'package:snap_like_app/constants/dimens.dart';
import 'package:snap_like_app/screens/map_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              fixedSize: MaterialStatePropertyAll(
                Size(double.infinity, 50),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.medium),
                ),
              ),
              elevation: MaterialStatePropertyAll(0),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Color.fromARGB(255, 150, 238, 96);
                }
                return Color.fromARGB(255, 2, 207, 36);
              })),
        ),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: MapScreen(),
    );
  }
}
