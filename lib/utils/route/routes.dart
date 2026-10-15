import 'package:flutter/material.dart';
import 'package:kids_learning_app/screens/about.dart';
import 'package:kids_learning_app/screens/explore/drawingboard.dart';
import 'package:kids_learning_app/screens/explore/explore.dart';
import 'package:kids_learning_app/screens/explore/quiz.dart';
import 'package:kids_learning_app/screens/home.dart';
import 'package:kids_learning_app/screens/landing_page.dart';
import 'package:kids_learning_app/screens/main_home.dart';
import 'package:kids_learning_app/screens/modules/animals.dart';
import 'package:kids_learning_app/screens/modules/atoz.dart';
import 'package:kids_learning_app/screens/modules/birds.dart';
import 'package:kids_learning_app/screens/modules/colors.dart';
import 'package:kids_learning_app/screens/modules/counting.dart';
import 'package:kids_learning_app/screens/modules/fruits.dart';
import 'package:kids_learning_app/screens/modules/parts.dart';
import 'package:kids_learning_app/screens/modules/planets.dart';
import 'package:kids_learning_app/screens/modules/table.dart';
import 'package:kids_learning_app/screens/splash_screen.dart';
import 'package:kids_learning_app/utils/route/page_transtion.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AllRoutesConstant.splashRoute:
        return slidePageRoute(const SplashScreen());
      case AllRoutesConstant.homeRoute:
        return slidePageRoute(const MyHomePage());
      case AllRoutesConstant.mainhomeRoute:
        return slidePageRoute(const MainHome());
      case AllRoutesConstant.landingRoute:
        return slidePageRoute(const LandingPage());
      case AllRoutesConstant.aboutRoute:
        return slidePageRoute(const AboutPage());
      case AllRoutesConstant.puzzleRoute:
        return slidePageRoute(const PuzzleScreen());
      case AllRoutesConstant.quizRoute:
        return slidePageRoute(const Quiz());
      case AllRoutesConstant.drawingboardRoute:
        return slidePageRoute(const DrawingBoardPage());

      // Learning modules
      case AllRoutesConstant.atozRoute:
        return slidePageRoute(const AtoZ());
      case AllRoutesConstant.animalRoute:
        return slidePageRoute(const AnimalsPage());
      case AllRoutesConstant.birdsRoute:
        return slidePageRoute(const BirdsPage());
      case AllRoutesConstant.partsRoute:
        return slidePageRoute(const PartsPage());
      case AllRoutesConstant.solarRoute:
        return slidePageRoute(const PlanetsPage());
      case AllRoutesConstant.colourRoute:
        return slidePageRoute(const ColoursPage());
      case AllRoutesConstant.fruitRoute:
        return slidePageRoute(const FruitsPage());
      case AllRoutesConstant.countingRoute:
        return slidePageRoute(const CountingPage());
      case AllRoutesConstant.tableRoute:
        return slidePageRoute(const TablePage());

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('No route found'))),
        );
    }
  }
}
