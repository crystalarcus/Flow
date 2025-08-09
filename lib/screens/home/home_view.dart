import 'package:flutter/material.dart';
import 'package:redesigned/screens/home/home_view_mobile.dart';
import 'package:redesigned/screens/home/home_view_desktop.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => constraints.maxWidth > 650
          ? const DesktopHomeView()
          : MobileHomeView(constraints: constraints)),
    );
  }
}
