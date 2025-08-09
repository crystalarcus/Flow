import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/navigation/router.dart';
import 'package:redesigned/core/services/app_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesigned/Components/Utils/classes.dart';
import 'package:redesigned/Components/Utils/data.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() async {
  // requestPermissions();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Provider<GoRouter>(create: (_) => router, child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
  // ignore: library_private_types_in_public_api
  static _MainAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>()!;
}

class _MainAppState extends State<MainApp> {
  ThemeMode themeMode = ThemeMode.system;
  void changeTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  Color seedColor = const Color.fromARGB(255, 111, 82, 138);
  bool isDark() {
    if (themeMode == ThemeMode.dark) {
      return true;
    }
    if (themeMode == ThemeMode.system &&
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark) {
      return true;
    }
    return false;
  }

  bool isSearchFloating = true;
  List<Person> myFollower = myFollowersConst;
  List<Person> myFriends = myFollowersConst.sublist(1, 5);

  bool isFollowing(Person p) {
    for (var element in myFollower) {
      if (element.userName == p.userName) {
        return true;
      }
    }
    return false;
  }

  bool isUserNameFollowing(String userName) {
    for (var element in myFollower) {
      if (element.userName == userName) {
        return true;
      }
    }
    return false;
  }

  bool isFriend(Person p) {
    for (var element in myFriends) {
      if (element.userName == p.userName) {
        return true;
      }
    }
    return false;
  }

  TextTheme textTheme = const TextTheme(
      // bodySmall: TextStyle(fontWeight: FontWeight.w500),
      // bodyMedium: TextStyle(fontWeight: FontWeight.w500),
      // bodyLarge: TextStyle(fontWeight: FontWeight.w500),
      // labelSmall: TextStyle(fontWeight: FontWeight.w500),
      // labelMedium: TextStyle(fontWeight: FontWeight.w500),
      // labelLarge: TextStyle(fontWeight: FontWeight.w500),
      );

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: MaterialApp.router(
        routerConfig: context.read<GoRouter>(),
        theme: ThemeData.from(
          textTheme: GoogleFonts.manropeTextTheme(textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        ),
        darkTheme: ThemeData.from(
            textTheme: GoogleFonts.manropeTextTheme(textTheme),
            colorScheme: ColorScheme.fromSeed(
                seedColor: seedColor, brightness: Brightness.dark)),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

List<Person> myFollowersConst = [
  accounts[3].person,
  accounts[4].person,
  accounts[5].person,
  accounts[6].person,
  accounts[7].person,
  accounts[12].person,
  accounts[15].person,
  accounts[19].person,
  accounts[24].person,
];

// Color getsurface {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 6 : 98));
// }

// Color getSurfaceDim() {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 6 : 87));
// }

// Color getSurfaceBright() {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 24 : 98));
// }

// Color getsurfaceContainerLowest {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 4 : 100));
// }

// Color getsurfaceContainerLow {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 10 : 96));
// }

// Color getsurfaceContainer {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 12 : 94));
// }

// Color getsurfaceContainerHigh {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 17 : 92));
// }

// Color getsurfaceContainerHighest {
//   CorePalette p = CorePalette.of(seedColor.value);
//   return Color(p.neutral.get(isDark() ? 22 : 90));
// }
