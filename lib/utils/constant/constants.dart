// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:kids_learning_app/model/animal_model.dart';
import 'package:kids_learning_app/model/bird_model.dart';
import 'package:kids_learning_app/model/fruit_model.dart';
import 'package:kids_learning_app/model/itemdata_model.dart';
import 'package:kids_learning_app/model/question_model.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import '../../model/planet_model.dart';
import '../../model/module.dart';
import 'package:kids_learning_app/utils/app_assets_path/assets_path.dart';

class AppConstants {
  ///   plantes
  static List<Planet> planets = [
    Planet(
      name: 'Sun',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.sun),
      description: 'Sun is the biggest star in the solar system.',
      backgroundColor: const Color.fromARGB(255, 208, 211, 23),
    ),
    Planet(
      name: 'Mercury',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.mercury),
      description: 'Mercury is the closest planet to the Sun.',
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
    ),
    Planet(
      name: 'Venus',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.venus),
      description: 'Venus is known for its thick atmosphere.',
      backgroundColor: const Color.fromARGB(255, 240, 193, 95),
    ),
    Planet(
      name: 'Earth',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.earth),
      description: 'Earth is the third planet from the Sun.',
      backgroundColor: const Color.fromARGB(255, 81, 149, 192),
    ),
    Planet(
      name: 'Mars',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.mars),
      description: 'Mars is often called the Red Planet.',
      backgroundColor: const Color.fromARGB(255, 238, 118, 96),
    ),
    Planet(
      name: 'Jupiter',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.jupiter),
      description: 'Jupiter is the largest planet in our solar system.',
      backgroundColor: const Color.fromARGB(255, 204, 164, 122),
    ),
    Planet(
      name: 'Saturn',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.saturn),
      description: 'Saturn is known for its beautiful rings.',
      backgroundColor: const Color.fromARGB(255, 229, 215, 194),
    ),
    Planet(
      name: 'Uranus',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.uranus),
      description: 'Uranus is an ice giant with a unique rotation axis.',
      backgroundColor: const Color.fromARGB(255, 169, 222, 246),
    ),
    Planet(
      name: 'Neptune',
      svgAsset: AssetsPath.getSolarImage(SolarSystem.neptune),
      description: 'Neptune is the farthest planet from the Sun.',
      backgroundColor: const Color.fromARGB(255, 64, 90, 200),
    ),
  ];

  ///  modules
  static List<Module> modules = [
    Module(
      name: 'A-Z',
      description: 'Learn A to Z with production and an example',
      thumbnailPath: AssetsPath.getAlphabetImage(Alphabets.alphabets),
      route: AllRoutesConstant.atozRoute, // Use route name
      backgroundColor: const Color.fromARGB(193, 76, 175, 79),
    ),
    Module(
      name: 'Birds',
      description: 'Look out for Birds with their sounds',
      thumbnailPath: AssetsPath.getBirdImage(Birds.birds),
      route: AllRoutesConstant.birdsRoute, // Use route name
      backgroundColor: const Color.fromARGB(193, 76, 207, 222),
    ),
    Module(
      name: "Animal",
      description: "Explore and Learn about the Animals",
      thumbnailPath: AssetsPath.getAnimalImage(Animals.animals),
      route: AllRoutesConstant.animalRoute, // Use route name
      backgroundColor: const Color.fromARGB(193, 21, 234, 28),
    ),
    Module(
      name: "Body Parts",
      description: "Explore and Learn about the Body Parts",
      thumbnailPath: AssetsPath.getBodyImage(Body.body),
      route: AllRoutesConstant.partsRoute, // Use route name
      backgroundColor: const Color.fromARGB(193, 76, 207, 222),
    ),
    Module(
      name: 'Quiz',
      description: 'Fun Quizzes for Curious Kids!',
      thumbnailPath: "./assets/images/quiz.jpg",
      route: AllRoutesConstant.quizRoute, // Use route name
      backgroundColor: const Color.fromARGB(193, 76, 175, 79),
    ),
    // Add other modules
  ];

  /// body parts
  static const List<String> candidates = [
    "Eye",
    "Lips",
    "Ankle",
    "Arm",
    "Back",
    "Belly",
    "Cheek",
    "Chest",
    "Chin",
    "Ear",
    "Elbow",
    "Foot",
    "Fingers",
    "Hair",
    "Hips",
    "Knee",
    "Leg",
    "Nail",
    "Neck",
    "Nose",
    "Palm",
    "Shoulder",
    "Stomach",
    "Teeth",
    "Thigh",
    "Thumb",
    "Toe",
    "Tongue",
    "Waist",
    "Wrist",
  ];

  ///  questions
  static List<Questions> ques = [
    Questions(
      question: "How many Orange Cars are there?",
      options: ["5", "6", "1", "2"],
      image: "assets/quiz/q1.jpg",
      answer: 3, // Index of the correct option, in this case, "Paris"
    ),
    Questions(
      question: "Count the Pokemons.",
      image: "assets/quiz/q2.jpg",

      options: ["11", "9", "10", "8"],
      answer: 2, // Index of the correct option, in this case, "Au"
    ),
    Questions(
      question: "1,2,_,4,5",
      options: ["5", "3", "6", "4"],
      answer: 1, // Index of the correct option, in this case, "105"
    ),
    Questions(
      question: "10,20_,40,50",
      options: ["60", "20", "30", "70"],
      answer: 2, // Index of the correct option, in this case, "Dart"
    ),
    Questions(
      question: "Count Yellow Bears.",
      image: "assets/quiz/q5.jpg",
      options: ["2", "3", "4", "5"],
      answer: 1, // Index of the correct option, in this case, "1492"
    ),
    Questions(
      question: "Count the Number of Balls",
      image: "assets/quiz/q6.jpg",
      options: ["5", "6", "4", "7"],
      answer: 0, // Index of the correct option, in this case, "1492"
    ),
    Questions(
      question: "Count Hearts",
      image: "assets/quiz/q7.jpg",
      options: ["10", "6", "9", "7"],
      answer: 3, // Index of the correct option, in this case, "1492"
    ),
    Questions(
      question: "Count Buckets",
      image: "assets/quiz/q9.jpg",
      options: ["1", "2", "3", "4"],
      answer: 0, // Index of the correct option, in this case, "1492"
    ),
    Questions(
      question: "Count the pencils",
      image: "assets/quiz/q10.jpg",
      options: ["10", "12", "13", "11"],
      answer: 2, // Index of the correct option, in this case, "1492"
    ),
  ];

  ///  alphabets

  static List<ItemData> alphabetItems = [
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.apple),
      title: 'A',
      description: 'Apple',
      backgroundColor: const Color.fromARGB(115, 171, 171, 171),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.ball),
      title: 'B',
      description: 'Ball',
      backgroundColor: const Color.fromARGB(115, 215, 118, 118),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.cat),
      title: 'C',
      description: 'Cat',
      backgroundColor: const Color.fromARGB(194, 130, 243, 69),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.dog),
      title: 'D',
      description: 'Dog',
      backgroundColor: const Color.fromARGB(115, 215, 199, 118),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.elephant),
      title: 'E',
      description: 'Elephant',
      backgroundColor: const Color.fromARGB(115, 118, 215, 173),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.fish),
      title: 'F',
      description: 'Fish',
      backgroundColor: const Color.fromARGB(115, 150, 118, 215),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.grapes),
      title: 'G',
      backgroundColor: const Color.fromARGB(115, 215, 118, 175),
      description: 'Grapes',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.horse),
      title: 'H',
      backgroundColor: const Color.fromARGB(115, 157, 215, 118),
      description: 'Horse',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.icecream),
      title: 'I',
      backgroundColor: const Color.fromARGB(221, 176, 102, 220),
      description: 'Ice-Cream',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.joker),
      title: 'J',
      description: 'Joker',
      backgroundColor: const Color.fromARGB(208, 112, 181, 206),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.king),
      title: 'K',
      backgroundColor: const Color.fromARGB(115, 171, 215, 118),
      description: 'King',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.lion),
      title: 'L',
      description: 'Lion',
      backgroundColor: const Color.fromARGB(236, 235, 229, 53),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.monkey),
      title: 'M',
      description: 'Monkey',
      backgroundColor: const Color.fromARGB(115, 118, 189, 215),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.nest),
      title: 'N',
      description: 'Nest',
      backgroundColor: const Color.fromARGB(115, 118, 215, 121),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.orange),
      title: 'O',
      description: 'Orange',
      backgroundColor: const Color.fromARGB(115, 215, 189, 118),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.parrot),
      title: 'P',
      backgroundColor: const Color.fromARGB(115, 120, 118, 215),
      description: 'Parrot',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.queen),
      title: 'Q',
      backgroundColor: const Color.fromARGB(115, 215, 118, 118),
      description: 'Queen',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.rabbit),
      title: 'R',
      description: 'Rabbit',
      backgroundColor: const Color.fromARGB(174, 134, 218, 191),
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.sheep),
      title: 'S',
      backgroundColor: const Color.fromARGB(170, 156, 216, 145),
      description: 'Sheep',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.table),
      title: 'T',
      backgroundColor: const Color.fromARGB(180, 138, 64, 228),
      description: 'Table',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.umbrella),
      title: 'U',
      backgroundColor: const Color.fromARGB(189, 212, 127, 220),
      description: 'Umbrella',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.van),
      title: 'V',
      backgroundColor: const Color.fromARGB(115, 215, 118, 118),
      description: 'Van',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.window),
      title: 'W',
      backgroundColor: const Color.fromARGB(246, 255, 194, 25),
      description: 'Window',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.xerox),
      title: 'X',
      backgroundColor: const Color.fromARGB(115, 0, 236, 71),
      description: 'Xerox',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.yellow),
      title: 'Y',
      backgroundColor: const Color.fromARGB(115, 9, 255, 230),
      description: 'Yellow',
    ),
    ItemData(
      iconAsset: AssetsPath.getAlphabetImage(Alphabets.zero),
      title: 'Z',
      backgroundColor: const Color.fromARGB(155, 81, 0, 255),
      description: 'Zero',
    ),
  ];

  /// animails

  static List<Animal> animals = [
    Animal(
      name: 'Cat',
      svgAsset: AssetsPath.getAnimalImage(Animals.cat),
      soundAsset: AssetsPath.getAnimalSound(Animals.catSound),
      backgroundColor: const Color.fromARGB(193, 76, 175, 79),
    ),
    Animal(
      name: 'Deer',
      svgAsset: AssetsPath.getAnimalImage(Animals.deer),
      soundAsset: AssetsPath.getAnimalSound(Animals.deerSound),
      backgroundColor: const Color.fromARGB(194, 157, 82, 222),
    ),
    Animal(
      name: 'Bear',
      svgAsset: AssetsPath.getAnimalImage(Animals.bear),
      soundAsset: AssetsPath.getAnimalSound(Animals.bearSound),
      backgroundColor: const Color.fromARGB(193, 76, 207, 222),
    ),
    Animal(
      name: 'Cow',
      svgAsset: AssetsPath.getAnimalImage(Animals.cow),
      soundAsset: AssetsPath.getAnimalSound(Animals.cowSound),
      backgroundColor: const Color.fromARGB(157, 251, 0, 0),
    ),
    Animal(
      name: 'Fox',
      svgAsset: AssetsPath.getAnimalImage(Animals.fox),
      soundAsset: AssetsPath.getAnimalSound(Animals.foxSound),
      backgroundColor: const Color.fromARGB(193, 21, 234, 28),
    ),
    Animal(
      name: 'Giraffe',
      svgAsset: AssetsPath.getAnimalImage(Animals.giraffe),
      soundAsset: AssetsPath.getAnimalSound(Animals.giraffeSound),
      backgroundColor: const Color.fromARGB(193, 226, 221, 70),
    ),
    Animal(
      name: 'Goat',
      svgAsset: AssetsPath.getAnimalImage(Animals.goat),
      soundAsset: AssetsPath.getAnimalSound(Animals.goatSound),
      backgroundColor: const Color.fromARGB(138, 48, 59, 48),
    ),
    Animal(
      name: 'Kangaroo',
      svgAsset: AssetsPath.getAnimalImage(Animals.kangaroo),
      soundAsset: AssetsPath.getAnimalSound(Animals.kangarooSound),
      backgroundColor: const Color.fromARGB(154, 221, 214, 209),
    ),
    Animal(
      name: 'Monkey',
      svgAsset: AssetsPath.getAnimalImage(Animals.monkey),
      soundAsset: AssetsPath.getAnimalSound(Animals.monkeySound),
      backgroundColor: const Color.fromARGB(193, 76, 175, 79),
    ),
    Animal(
      name: 'Pig',
      svgAsset: AssetsPath.getAnimalImage(Animals.pig),
      soundAsset: AssetsPath.getAnimalSound(Animals.pigSound),
      backgroundColor: const Color.fromARGB(151, 40, 137, 248),
    ),
    Animal(
      name: 'Sheep',
      svgAsset: AssetsPath.getAnimalImage(Animals.sheep),
      soundAsset: AssetsPath.getAnimalSound(Animals.sheepSound),
      backgroundColor: const Color.fromARGB(193, 240, 241, 170),
    ),
    Animal(
      name: 'Snake',
      svgAsset: AssetsPath.getAnimalImage(Animals.snake),
      soundAsset: AssetsPath.getAnimalSound(Animals.snakeSound),
      backgroundColor: const Color.fromARGB(193, 125, 176, 127),
    ),
    Animal(
      name: 'Squirrel',
      svgAsset: AssetsPath.getAnimalImage(Animals.squirrel),
      soundAsset: AssetsPath.getAnimalSound(Animals.squirrelSound),
      backgroundColor: const Color.fromARGB(139, 175, 140, 76),
    ),
    Animal(
      name: 'Tiger',
      svgAsset: AssetsPath.getAnimalImage(Animals.tiger),
      soundAsset: AssetsPath.getAnimalSound(Animals.tigerSound),
      backgroundColor: const Color.fromARGB(157, 251, 151, 0),
    ),
    Animal(
      name: 'Zebra',
      svgAsset: AssetsPath.getAnimalImage(Animals.zebra),
      soundAsset: AssetsPath.getAnimalSound(Animals.zebraSound),
      backgroundColor: const Color.fromARGB(193, 187, 74, 178),
    ),
    Animal(
      name: 'Dog',
      svgAsset: AssetsPath.getAnimalImage(Animals.dog),
      soundAsset: AssetsPath.getAnimalSound(Animals.dogSound),
      backgroundColor: const Color.fromARGB(193, 33, 149, 243),
    ),
    Animal(
      name: 'Elephant',
      svgAsset: AssetsPath.getAnimalImage(Animals.elephant),
      soundAsset: AssetsPath.getAnimalSound(Animals.elephantSound),
      backgroundColor: const Color.fromARGB(193, 182, 221, 252),
    ),
    Animal(
      name: 'Horse',
      svgAsset: AssetsPath.getAnimalImage(Animals.horse),
      soundAsset: AssetsPath.getAnimalSound(Animals.horseSound),
      backgroundColor: const Color.fromARGB(98, 243, 201, 33),
    ),
    Animal(
      name: 'Lion',
      svgAsset: AssetsPath.getAnimalImage(Animals.lion),
      soundAsset: AssetsPath.getAnimalSound(Animals.lionSound),
      backgroundColor: const Color.fromARGB(193, 43, 197, 35),
    ),
    Animal(
      name: 'Rabbit',
      svgAsset: AssetsPath.getAnimalImage(Animals.rabbit),
      soundAsset: AssetsPath.getAnimalSound(Animals.rabbitSound),
      backgroundColor: const Color.fromARGB(156, 243, 33, 236),
    ),
  ];

  ///  birds
  static List<Bird> birds = [
    Bird(
      name: 'Sparrow',
      jpgAsset: AssetsPath.getBirdImage(Birds.sparrow),
      soundAsset: AssetsPath.getBirdSound(Birds.sparrowSound),
      backgroundColor: const Color.fromARGB(193, 76, 175, 79),
    ),
    Bird(
      name: 'Robin',
      jpgAsset: AssetsPath.getBirdImage(Birds.robin),
      soundAsset: AssetsPath.getBirdSound(Birds.robinSound),
      backgroundColor: const Color.fromARGB(194, 157, 82, 222),
    ),
    Bird(
      name: 'Crow',
      jpgAsset: AssetsPath.getBirdImage(Birds.crow),
      soundAsset: AssetsPath.getBirdSound(Birds.crowSound),
      backgroundColor: const Color.fromARGB(193, 76, 207, 222),
    ),
    Bird(
      name: 'Seagull',
      jpgAsset: AssetsPath.getBirdImage(Birds.seagull),
      soundAsset: AssetsPath.getBirdSound(Birds.seagullSound),
      backgroundColor: const Color.fromARGB(193, 21, 234, 28),
    ),
    Bird(
      name: 'Duck',
      jpgAsset: AssetsPath.getBirdImage(Birds.duck),
      soundAsset: AssetsPath.getBirdSound(Birds.duckSound),
      backgroundColor: const Color.fromARGB(193, 226, 221, 70),
    ),
    Bird(
      name: 'Hen',
      jpgAsset: AssetsPath.getBirdImage(Birds.hen),
      soundAsset: AssetsPath.getBirdSound(Birds.henSound),
      backgroundColor: const Color.fromARGB(138, 48, 59, 48),
    ),
    Bird(
      name: 'Eagle',
      jpgAsset: AssetsPath.getBirdImage(Birds.eagle),
      soundAsset: AssetsPath.getBirdSound(Birds.eagleSound),
      backgroundColor: const Color.fromARGB(154, 221, 214, 209),
    ),
    Bird(
      name: 'Owl',
      jpgAsset: AssetsPath.getBirdImage(Birds.owl),
      soundAsset: AssetsPath.getBirdSound(Birds.owlSound),
      backgroundColor: const Color.fromARGB(193, 76, 175, 79),
    ),
    Bird(
      name: 'Hummingbird',
      jpgAsset: AssetsPath.getBirdImage(Birds.hummingbird),
      soundAsset: AssetsPath.getBirdSound(Birds.hummingbirdSound),
      backgroundColor: const Color.fromARGB(151, 40, 137, 248),
    ),
    Bird(
      name: 'Parrot',
      jpgAsset: AssetsPath.getBirdImage(Birds.parrot),
      soundAsset: AssetsPath.getBirdSound(Birds.parrotSound),
      backgroundColor: const Color.fromARGB(193, 240, 241, 170),
    ),
    Bird(
      name: 'Swan',
      jpgAsset: AssetsPath.getBirdImage(Birds.swan),
      soundAsset: AssetsPath.getBirdSound(Birds.swanSound),
      backgroundColor: const Color.fromARGB(193, 125, 176, 127),
    ),
    Bird(
      name: 'Goose',
      jpgAsset: AssetsPath.getBirdImage(Birds.goose),
      soundAsset: AssetsPath.getBirdSound(Birds.gooseSound),
      backgroundColor: const Color.fromARGB(139, 175, 140, 76),
    ),
    Bird(
      name: 'Woodpecker',
      jpgAsset: AssetsPath.getBirdImage(Birds.woodpecker),
      soundAsset: AssetsPath.getBirdSound(Birds.woodpeckerSound),
      backgroundColor: const Color.fromARGB(157, 251, 151, 0),
    ),
    Bird(
      name: 'Kingfisher',
      jpgAsset: AssetsPath.getBirdImage(Birds.kingfisher),
      soundAsset: AssetsPath.getBirdSound(Birds.kingfisherSound),
      backgroundColor: const Color.fromARGB(193, 187, 74, 178),
    ),
    Bird(
      name: 'Ostrich',
      jpgAsset: AssetsPath.getBirdImage(Birds.ostrich),
      soundAsset: AssetsPath.getBirdSound(Birds.ostrichSound),
      backgroundColor: const Color.fromARGB(193, 182, 221, 252),
    ),
    Bird(
      name: 'Vulture',
      jpgAsset: AssetsPath.getBirdImage(Birds.vulture),
      soundAsset: AssetsPath.getBirdSound(Birds.vultureSound),
      backgroundColor: const Color.fromARGB(98, 243, 201, 33),
    ),
    Bird(
      name: 'Maina',
      jpgAsset: AssetsPath.getBirdImage(Birds.maina),
      soundAsset: AssetsPath.getBirdSound(Birds.mainaSound),
      backgroundColor: const Color.fromARGB(255, 73, 179, 63),
    ),
    Bird(
      name: 'Bulbul',
      jpgAsset: AssetsPath.getBirdImage(Birds.bulbul),
      soundAsset: AssetsPath.getBirdSound(Birds.bulbulSound),
      backgroundColor: const Color.fromARGB(156, 128, 222, 243),
    ),
    Bird(
      name: 'Koel',
      jpgAsset: AssetsPath.getBirdImage(Birds.koel),
      soundAsset: AssetsPath.getBirdSound(Birds.koelSound),
      backgroundColor: const Color.fromARGB(232, 141, 255, 93),
    ),
    Bird(
      name: 'Baya',
      jpgAsset: AssetsPath.getBirdImage(Birds.baya),
      soundAsset: AssetsPath.getBirdSound(Birds.bayaSound),
      backgroundColor: const Color.fromARGB(193, 106, 190, 101),
    ),
    Bird(
      name: 'Bagula',
      jpgAsset: AssetsPath.getBirdImage(Birds.bagula),
      soundAsset: AssetsPath.getBirdSound(Birds.bagulaSound),
      backgroundColor: const Color.fromARGB(156, 248, 248, 248),
    ),
  ];

  /// fruits

  static List<Fruit> Fruits = [
    Fruit(
      name: 'Apple',
      svgAsset: 'assets/fruitsVeges/apple.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'Banana',
      svgAsset: 'assets/fruitsVeges/banana.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'Carrot',
      svgAsset: 'assets/fruitsVeges/carrot.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Red Chilli',
      svgAsset: 'assets/fruitsVeges/chilli.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Eggplant',
      svgAsset: 'assets/fruitsVeges/eggplant.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Ginger',
      svgAsset: 'assets/fruitsVeges/ginger.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Grapes',
      svgAsset: 'assets/fruitsVeges/grapes.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'Kiwi',
      svgAsset: 'assets/fruitsVeges/kiwi.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'Okra',
      svgAsset: 'assets/fruitsVeges/okra.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Onion',
      svgAsset: 'assets/fruitsVeges/onion.png',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Orange',
      svgAsset: 'assets/fruitsVeges/orange.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'Pineapple',
      svgAsset: 'assets/fruitsVeges/pineapple.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'potato',
      svgAsset: 'assets/fruitsVeges/potato.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Strawberry',
      svgAsset: 'assets/fruitsVeges/strawberry.png',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
    Fruit(
      name: 'tomato',
      svgAsset: 'assets/fruitsVeges/tomato.svg',
      backgroundColor: Colors.white,
      isfruit: false,
    ),
    Fruit(
      name: 'Watermelon',
      svgAsset: 'assets/fruitsVeges/watermelon.svg',
      backgroundColor: Colors.white,
      isfruit: true,
    ),
  ];

  static const String a_z = 'A-Z';
  static const String bird = 'Birds';
  static const String animal = 'Animals';
  static const String parts = 'Body Parts';
  static const String shape = 'Shapes';
  static const String solar = 'Solar System';
  static const String color = 'Colours';
  static const String fruit = 'Fruits & Vegetables';
  static const String description =
      'Interactive app to let your kids learn various things like\n\n - A - Z alphabets.\n - Animals and their sounds.\n - Birds and their sounds.\n - Various shapes.\n - Body parts.\n - Solar system.\n';
}
