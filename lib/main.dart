import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:kids_learning_app/provider/favorite_page_provider.dart';
import 'package:kids_learning_app/provider/theme_provider.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import 'package:kids_learning_app/utils/route/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdaptiveTheme.getThemeMode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteScreenProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KiddoMind',

            theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,

            initialRoute: AllRoutesConstant.splashRoute,
            onGenerateRoute: Routers.generateRoute,
          );
        },
      ),
    );
  }
}
