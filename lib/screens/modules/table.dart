import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// ================= TABLE MODEL =================
class TableItem {
  final int number;
  final String emoji;
  final Color color;

  TableItem({
    required this.number,
    required this.emoji,
    required this.color,
  });
}

/// ================= MAIN PAGE =================
class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isQuizMode = false;

  final List<TableItem> tables = [
    TableItem(number: 2, emoji: "2️⃣", color: Colors.red),
    TableItem(number: 3, emoji: "3️⃣", color: Colors.orange),
    TableItem(number: 4, emoji: "4️⃣", color: Colors.yellow),
    TableItem(number: 5, emoji: "5️⃣", color: Colors.green),
    TableItem(number: 6, emoji: "6️⃣", color: Colors.blue),
    TableItem(number: 7, emoji: "7️⃣", color: Colors.indigo),
    TableItem(number: 8, emoji: "8️⃣", color: Colors.purple),
    TableItem(number: 9, emoji: "9️⃣", color: Colors.pink),
    TableItem(number: 10, emoji: "🔟", color: Colors.teal),
  ];

  @override
  void initState() {
    super.initState();
    _setupTts();
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.2);
    await flutterTts.setVolume(1.0);
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
              "✖️ Tables!",
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
                  flutterTts.speak("Let's play a multiplication puzzle game!");
                } else {
                  flutterTts.speak("Let's learn multiplication tables!");
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
          ? TableQuizWidget(tables: tables, flutterTts: flutterTts)
          : TableLearnWidget(tables: tables, flutterTts: flutterTts),
    );
  }
}

/// ================= LEARN MODE =================
class TableLearnWidget extends StatefulWidget {
  final List<TableItem> tables;
  final FlutterTts flutterTts;

  const TableLearnWidget({
    super.key,
    required this.tables,
    required this.flutterTts,
  });

  @override
  State<TableLearnWidget> createState() => _TableLearnWidgetState();
}

class _TableLearnWidgetState extends State<TableLearnWidget>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int currentMultiplier = 1;
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
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  void _next() {
    setState(() {
      currentMultiplier++;
      if (currentMultiplier > 10) {
        currentMultiplier = 1;
        currentIndex = (currentIndex + 1) % widget.tables.length;
      }
      _animationController.reset();
      _animationController.forward();
    });
    _speak();
  }

  void _prev() {
    setState(() {
      currentMultiplier--;
      if (currentMultiplier < 1) {
        currentMultiplier = 10;
        currentIndex = (currentIndex - 1 + widget.tables.length) % widget.tables.length;
      }
      _animationController.reset();
      _animationController.forward();
    });
    _speak();
  }

  Future<void> _speak() async {
    final table = widget.tables[currentIndex];
    final result = table.number * currentMultiplier;
    await widget.flutterTts.setLanguage("en-US");
    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.2);
    await widget.flutterTts.speak(
        "${table.number} times $currentMultiplier equals $result"
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0) {
        _next();
      } else if (details.primaryVelocity! > 0) {
        _prev();
      }
    }
  }

  void _changeTable(int index) {
    setState(() {
      currentIndex = index;
      currentMultiplier = 1;
      _animationController.reset();
      _animationController.forward();
    });
    _speak();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tableItem = widget.tables[currentIndex];
    final result = tableItem.number * currentMultiplier;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(
                widget.tables.length,
                    (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= currentIndex
                          ? Colors.orange
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: index == currentIndex
                        ? Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
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
          const SizedBox(height: 10),
          // Table selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.tables.length, (index) {
                  final table = widget.tables[index];
                  final isSelected = index == currentIndex;
                  return GestureDetector(
                    onTap: () => _changeTable(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? table.color
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? table.color
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "Table ${table.number}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Main card
          Expanded(
            child: GestureDetector(
              onTap: _speak,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              tableItem.color.withOpacity(0.8),
                              tableItem.color.withOpacity(0.4),
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: tableItem.color.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 6,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative stars
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Text(
                                "✨",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: _getTextColor(tableItem.color)
                                      .withOpacity(0.3),
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
                                  color: _getTextColor(tableItem.color)
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                            // Main content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tableItem.emoji,
                                    style: const TextStyle(
                                      fontSize: 60,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 20,
                                          color: Colors.black26,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "$currentMultiplier × ${tableItem.number} = $result",
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: _getTextColor(tableItem.color),
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTextColor(tableItem.color)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Table of ${tableItem.number}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _getTextColor(tableItem.color)
                                            .withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
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
          const SizedBox(height: 20),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _navButton(
                Icons.arrow_back_ios_rounded,
                "👈",
                _prev,
              ),
              const SizedBox(width: 20),
              _navButton(
                Icons.volume_up_rounded,
                "🔊",
                _speak,
              ),
              const SizedBox(width: 20),
              _navButton(
                Icons.arrow_forward_ios_rounded,
                "👉",
                _next,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Swipe left or right to change! ✖️",
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

  Color _getTextColor(Color bgColor) {
    return bgColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
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
}

/// ================= QUIZ MODE (PUZZLE STYLE) =================
class TableQuizWidget extends StatefulWidget {
  final List<TableItem> tables;
  final FlutterTts flutterTts;

  const TableQuizWidget({
    super.key,
    required this.tables,
    required this.flutterTts,
  });

  @override
  State<TableQuizWidget> createState() => _TableQuizWidgetState();
}

class _TableQuizWidgetState extends State<TableQuizWidget>
    with SingleTickerProviderStateMixin {
  final Random random = Random();

  int currentQuestionIndex = 0;
  int score = 0;
  int attempts = 0;
  List<Map<String, dynamic>> questions = [];
  late int currentTable;
  late int currentMultiplier;
  late int correctAnswer;
  List<int> options = [];
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
      final tableIndex = random.nextInt(widget.tables.length);
      final table = widget.tables[tableIndex];
      final multiplier = random.nextInt(10) + 1;
      return {
        'table': table,
        'multiplier': multiplier,
        'answer': table.number * multiplier,
      };
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
    final q = questions[currentQuestionIndex];
    currentTable = q['table'].number;
    currentMultiplier = q['multiplier'];
    correctAnswer = q['answer'];
    _generateOptions();
    answered = false;
    selectedOptionIndex = -1;
    attempts = 0;
    setState(() {});
    _animationController.reset();
    _animationController.forward();

    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.1);
    await widget.flutterTts.speak(
        "What is $currentTable times $currentMultiplier?"
    );
  }

  void _generateOptions() {
    List<int> candidateOptions = [correctAnswer];
    while (candidateOptions.length < 4) {
      int offset = random.nextInt(10) + 1;
      int opt = correctAnswer + (random.nextBool() ? offset : -offset);
      if (opt > 0 && !candidateOptions.contains(opt)) {
        candidateOptions.add(opt);
      }
    }
    candidateOptions.shuffle(random);
    options = candidateOptions;
  }

  void _checkAnswer(int selectedIndex) async {
    if (answered) return;

    final selected = options[selectedIndex];
    attempts++;

    if (selected == correctAnswer) {
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

    final tableItem = widget.tables.firstWhere(
          (t) => t.number == currentTable,
      orElse: () => widget.tables[0],
    );

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
          // Question display with shake animation
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value * 10, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          tableItem.color.withOpacity(0.8),
                          tableItem.color.withOpacity(0.4),
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: tableItem.color.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: answered && isCorrect
                            ? Colors.green
                            : answered && !isCorrect
                            ? Colors.red
                            : Colors.white.withOpacity(0.8),
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
                            "⭐",
                            style: TextStyle(
                              fontSize: 30,
                              color: _getTextColor(tableItem.color)
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Text(
                            "✖️",
                            style: TextStyle(
                              fontSize: 30,
                              color: _getTextColor(tableItem.color)
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tableItem.emoji,
                                style: const TextStyle(
                                  fontSize: 60,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 20,
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "$currentTable × $currentMultiplier = ?",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: _getTextColor(tableItem.color),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              if (answered && isCorrect)
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
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
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                            ],
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
          // Question text with attempt indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "❓ What is the answer?",
                  style: TextStyle(
                    fontSize: 22,
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
                              option.toString(),
                              style: TextStyle(
                                fontSize: 24,
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
                  ? "🎉 Amazing! Moving to next question!"
                  : answered && !isCorrect
                  ? "💪 Try again! You can do it!"
                  : "👆 Tap the correct answer!",
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
                          "✖️ TABLES COMPLETE!",
                          style: TextStyle(
                            fontSize: 32,
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
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade200,
                      Colors.pink.shade200,
                      Colors.purple.shade200,
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
    if (score >= 90) return "🎉 Perfect! You're a math superstar! ⭐";
    if (score >= 70) return "🌟 Amazing! You really know your tables!";
    if (score >= 50) return "😊 Good job! Keep practicing!";
    if (score >= 30) return "💪 Nice try! Let's learn more tables!";
    return "🌈 Don't worry! Practice makes perfect! You can do it!";
  }

  Color _getTextColor(Color bgColor) {
    return bgColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}