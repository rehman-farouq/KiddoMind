import 'package:flutter/material.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/core/progress_provider.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import 'package:kids_learning_app/utils/route/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAudio.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KiddoMind',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
        initialRoute: AllRoutesConstant.splashRoute,
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }
}
