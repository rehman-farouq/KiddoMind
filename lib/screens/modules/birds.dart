import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kids_learning_app/model/bird_model.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';

/// ================= MAIN PAGE =================
class BirdsPage extends StatefulWidget {
  const BirdsPage({super.key});

  @override
  State<BirdsPage> createState() => _BirdsPageState();
}

class _BirdsPageState extends State<BirdsPage> {
  late final FlutterTts _flutterTts;
  late final AudioPlayer _audioPlayer;
  bool isQuizMode = false;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer();
    _setupTts();
  }

  Future<void> _setupTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.2);
    await _flutterTts.setVolume(1.0);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "🐦 Birds!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isQuizMode = !isQuizMode;
                });
                if (isQuizMode) {
                  _flutterTts.speak("Let's play a birds puzzle game!");
                } else {
                  _flutterTts.speak("Let's learn about birds!");
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isQuizMode ? Icons.emoji_emotions : Icons.school,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isQuizMode ? "🎯 Quiz" : "📖 Learn",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: isQuizMode
          ? BirdsQuizWidget(
        birds: AppConstants.birds,
        flutterTts: _flutterTts,
        audioPlayer: _audioPlayer,
      )
          : BirdsLearnWidget(
        birds: AppConstants.birds,
        flutterTts: _flutterTts,
        audioPlayer: _audioPlayer,
      ),
    );
  }
}

/// ================= LEARN MODE =================
class BirdsLearnWidget extends StatefulWidget {
  final List<Bird> birds;
  final FlutterTts flutterTts;
  final AudioPlayer audioPlayer;

  const BirdsLearnWidget({
    super.key,
    required this.birds,
    required this.flutterTts,
    required this.audioPlayer,
  });

  @override
  State<BirdsLearnWidget> createState() => _BirdsLearnWidgetState();
}

class _BirdsLearnWidgetState extends State<BirdsLearnWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextBird() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.birds.length;
      _animationController.reset();
      _animationController.forward();
    });
    _speakBirdName(widget.birds[_currentIndex].name);
  }

  void _prevBird() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.birds.length) % widget.birds.length;
      _animationController.reset();
      _animationController.forward();
    });
    _speakBirdName(widget.birds[_currentIndex].name);
  }

  Future<void> _speakBirdName(String name) async {
    await widget.flutterTts.setLanguage("en-US");
    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.2);
    await widget.flutterTts.speak(name);
  }

  Future<void> _playBirdSound(String asset) async {
    try {
      await widget.audioPlayer.setAsset(asset);
      await widget.audioPlayer.play();
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBird = widget.birds[_currentIndex];
    final totalBirds = widget.birds.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(
                totalBirds,
                    (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentIndex
                          ? Colors.amber
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: index == _currentIndex
                        ? Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Bird image with animation
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () => _speakBirdName(currentBird.name),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              currentBird.backgroundColor.withOpacity(0.8),
                              currentBird.backgroundColor,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: currentBird.backgroundColor.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 4,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative elements
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Text(
                                "🐦",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Text(
                                "🌟",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            // Bird image
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    currentBird.jpgAsset,
                                    height: 220,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Bird name and info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: currentBird.backgroundColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getBirdEmoji(currentBird.name),
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentBird.name,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: currentBird.backgroundColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "👆 Tap to hear the name!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _navButton(
                Icons.arrow_back_ios_rounded,
                "👈",
                _prevBird,
              ),
              const SizedBox(width: 12),
              _navButton(
                Icons.volume_up_rounded,
                "🔊",
                    () => _speakBirdName(currentBird.name),
              ),
              const SizedBox(width: 12),
              _soundButton(
                    () => _playBirdSound(currentBird.soundAsset),
              ),
              const SizedBox(width: 12),
              _navButton(
                Icons.arrow_forward_ios_rounded,
                "👉",
                _nextBird,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Swipe or tap arrows to explore! 🐦",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _getBirdEmoji(String name) {
    final emojis = {
      "Sparrow": "🐦",
      "Robin": "🐦",
      "Crow": "🐦",
      "Seagull": "🐦",
      "Duck": "🦆",
      "Hen": "🐔",
      "Eagle": "🦅",
      "Owl": "🦉",
      "Hummingbird": "🐦",
      "Parrot": "🦜",
      "Swan": "🦢",
      "Goose": "🦆",
      "Woodpecker": "🐦",
      "Kingfisher": "🐦",
      "Ostrich": "🐦",
      "Vulture": "🐦",
      "Maina": "🐦",
      "Bulbul": "🐦",
      "Koel": "🐦",
      "Baya": "🐦",
      "Bagula": "🐦",
    };
    return emojis[name] ?? "🐦";
  }

  Widget _navButton(IconData icon, String emoji, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: icon == Icons.volume_up_rounded
                ? const Icon(
              Icons.volume_up_rounded,
              color: Colors.white,
              size: 32,
            )
                : Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _soundButton(VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child:  Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= QUIZ MODE (PUZZLE STYLE) =================
class BirdsQuizWidget extends StatefulWidget {
  final List<Bird> birds;
  final FlutterTts flutterTts;
  final AudioPlayer audioPlayer;

  const BirdsQuizWidget({
    super.key,
    required this.birds,
    required this.flutterTts,
    required this.audioPlayer,
  });

  @override
  State<BirdsQuizWidget> createState() => _BirdsQuizWidgetState();
}

class _BirdsQuizWidgetState extends State<BirdsQuizWidget>
    with SingleTickerProviderStateMixin {
  final Random random = Random();

  int currentQuestionIndex = 0;
  int score = 0;
  int attempts = 0;
  List<Bird> questions = [];
  late Bird currentQuestion;
  List<String> options = [];
  bool answered = false;
  bool isCorrect = false;
  bool showResult = false;
  int selectedOptionIndex = -1;
  List<int> wrongAttempts = [];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _startNewQuiz();
  }

  void _startNewQuiz() async {
    questions = List.generate(10, (_) {
      final randomIndex = random.nextInt(widget.birds.length);
      return widget.birds[randomIndex];
    });
    currentQuestionIndex = 0;
    score = 0;
    attempts = 0;
    wrongAttempts = [];
    showResult = false;
    answered = false;
    selectedOptionIndex = -1;
    _loadQuestion();
  }

  void _loadQuestion() async {
    if (currentQuestionIndex >= 10) {
      setState(() {
        showResult = true;
        _animationController.forward();
      });
      await widget.flutterTts.speak("Quiz complete! Well done!");
      return;
    }
    currentQuestion = questions[currentQuestionIndex];
    _generateOptions();
    answered = false;
    selectedOptionIndex = -1;
    attempts = 0;
    setState(() {});
    _animationController.reset();
    _animationController.forward();

    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.1);
    await widget.flutterTts.speak("What bird is this?");
  }

  void _generateOptions() {
    List<String> candidateNames = widget.birds.map((b) => b.name).toList();
    candidateNames.shuffle(random);
    options = [];
    options.add(currentQuestion.name);
    while (options.length < 4) {
      final candidate = candidateNames[random.nextInt(candidateNames.length)];
      if (!options.contains(candidate)) {
        options.add(candidate);
      }
    }
    options.shuffle(random);
  }

  void _checkAnswer(int selectedIndex) async {
    if (answered) return;

    final selected = options[selectedIndex];
    attempts++;

    if (selected == currentQuestion.name) {
      setState(() {
        answered = true;
        selectedOptionIndex = selectedIndex;
        isCorrect = true;
        if (attempts == 1) {
          score += 10;
        } else if (attempts == 2) {
          score += 5;
        } else if (attempts == 3) {
          score += 2;
        }
        wrongAttempts.add(attempts - 1);
      });

      await widget.flutterTts.setSpeechRate(0.6);
      await widget.flutterTts.setPitch(1.3);

      String feedback = "Correct! ";
      if (attempts == 1) feedback += "Perfect! 🌟";
      else if (attempts == 2) feedback += "Good job! 👍";
      else if (attempts == 3) feedback += "Well done! 💪";
      else feedback += "You got it! 🎯";

      await widget.flutterTts.speak(feedback);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          currentQuestionIndex++;
          _loadQuestion();
        }
      });
    } else {
      setState(() {
        selectedOptionIndex = selectedIndex;
        isCorrect = false;
        answered = true;
      });

      await widget.flutterTts.setSpeechRate(0.4);
      await widget.flutterTts.setPitch(0.8);

      String encouragement = "Oops! That's not right. ";
      if (attempts == 1) encouragement += "Try again! 💪";
      else if (attempts == 2) encouragement += "One more try! 🌟";
      else if (attempts == 3) encouragement += "You can do it! 🎯";
      else encouragement += "Keep trying! 🌈";

      await widget.flutterTts.speak(encouragement);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            answered = false;
            selectedOptionIndex = -1;
            isCorrect = false;
          });
        }
      });
    }
  }

  void _restartQuiz() {
    _startNewQuiz();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      return _buildResultScreen();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Score and progress
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScoreChip("🎯", "Q${currentQuestionIndex + 1}/10"),
                _buildScoreChip("⭐", "$score pts"),
                _buildScoreChip("💪", "${attempts > 0 ? attempts : 0} tries"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Bird display
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value * 10, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          currentQuestion.backgroundColor.withOpacity(0.8),
                          currentQuestion.backgroundColor,
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: currentQuestion.backgroundColor.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: answered && isCorrect
                            ? Colors.green
                            : answered && !isCorrect
                            ? Colors.red
                            : currentQuestion.backgroundColor.withOpacity(0.5),
                        width: answered ? 6 : 4,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative elements
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Text(
                            "🐦",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Text(
                            "❓",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        // Bird image
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                currentQuestion.jpgAsset,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        if (answered && isCorrect)
                          Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                attempts == 1
                                    ? "⭐ PERFECT!"
                                    : attempts == 2
                                    ? "👍 GOOD!"
                                    : attempts == 3
                                    ? "💪 WELL DONE!"
                                    : "✅ CORRECT!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Question text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "❓ What bird is this?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
                if (attempts > 0 && !answered)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Try $attempts",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Options grid
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                bool isSelected = selectedOptionIndex == index;
                bool showCorrect = answered && isSelected && isCorrect;
                bool showWrong = answered && isSelected && !isCorrect;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: showCorrect
                        ? const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    )
                        : showWrong
                        ? const LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                    )
                        : LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: showCorrect
                          ? Colors.green
                          : showWrong
                          ? Colors.red
                          : Colors.grey.shade300,
                      width: showCorrect || showWrong ? 4 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: showCorrect
                            ? Colors.green.withOpacity(0.3)
                            : showWrong
                            ? Colors.red.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: showCorrect || showWrong ? 15 : 5,
                        spreadRadius: showCorrect || showWrong ? 3 : 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: answered ? null : () => _checkAnswer(index),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (showCorrect)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 28,
                              ),
                            if (showWrong)
                              const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 28,
                              ),
                            if (showCorrect || showWrong)
                              const SizedBox(width: 8),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: (showCorrect || showWrong)
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              answered && isCorrect
                  ? "🎉 Amazing! Moving to next bird!"
                  : answered && !isCorrect
                  ? "💪 Try again! You can do it!"
                  : "👆 Tap the correct bird name!",
              style: TextStyle(
                color: answered && isCorrect
                    ? Colors.green.shade700
                    : answered && !isCorrect
                    ? Colors.red.shade700
                    : Colors.amber.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    double avgAttempts = wrongAttempts.isEmpty
        ? 0
        : wrongAttempts.reduce((a, b) => a + b) / wrongAttempts.length;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          score >= 80 ? "🌟" : score >= 60 ? "😊" : "💪",
                          style: const TextStyle(fontSize: 80),
                        ),
                        const Text(
                          "🐦 BIRD QUIZ COMPLETE!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B6B),
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black12,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("⭐", "$score", "Points"),
                    _buildStatItem("🎯", "${10 - wrongAttempts.length}", "Correct"),
                    _buildStatItem("💪",
                        avgAttempts == 0 ? "0" : avgAttempts.toStringAsFixed(1),
                        "Avg Tries"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFF8E53),
                      Color(0xFFFFC107),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$score",
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.black26,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "/ 100",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _getResultMessage(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildResultButton(
                    "🔄 Play Again",
                    Colors.green,
                    _restartQuiz,
                  ),
                  const SizedBox(width: 16),
                  _buildResultButton(
                    "📚 Learn",
                    Colors.blue,
                        () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B6B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildResultButton(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getResultMessage() {
    if (score >= 90) return "🎉 Perfect! You're a bird superstar! ⭐";
    if (score >= 70) return "🌟 Amazing! You know your birds well!";
    if (score >= 50) return "😊 Good job! Keep learning!";
    if (score >= 30) return "💪 Nice try! Let's learn more birds!";
    return "🌈 Don't worry! Every bird is special!";
  }
}