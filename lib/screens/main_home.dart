import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kids_learning_app/cubit/index_cubit.dart';
import 'package:kids_learning_app/screens/about.dart';
import 'package:kids_learning_app/screens/explore/explore.dart';
import 'package:kids_learning_app/screens/home.dart';
import 'package:kids_learning_app/widgets/drawer.dart';

class MainHome extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MainHome({super.key, this.savedThemeMode});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  bool _onBackPressed(bool canPop) {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(
        msg: "Press back again to exit 🧸",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      return false;
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => _onBackPressed(didPop),
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        ),
        dark: ThemeData.dark(),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return BlocProvider(
            create: (context) => IndexCubit(),
            child: BlocBuilder<IndexCubit, int>(
              builder: (context, index) {
                return Scaffold(
                  backgroundColor: const Color(0xFFFFF8E1),
                  body: const MyHomePage(),
                  drawer: const MyDrawer(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}