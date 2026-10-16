import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawingBoardPage extends StatelessWidget {
  const DrawingBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawingBoard();
  }
}

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard>
    with SingleTickerProviderStateMixin {
  Color selectedColor = Colors.black;
  double strokeWidth = 6.0;
  bool isEraser = false;
  bool isRainbowMode = false;
  int currentColorIndex = 0;

  List<DrawingPoint?> points = [];
  List<List<DrawingPoint?>> undoStack = [];
  int currentStrokeIndex = -1;

  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  final List<Color> colors = const [
    Colors.pink,
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.black,
    Colors.brown,
    Colors.cyan,
    Colors.teal,
    Colors.indigo,
  ];

  final List<Color> rainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _saveState() {
    if (points.isNotEmpty) {
      setState(() {
        undoStack.add(List.from(points));
        if (undoStack.length > 20) undoStack.removeAt(0);
        currentStrokeIndex = undoStack.length - 1;
      });
    }
  }

  void _undo() {
    if (undoStack.isNotEmpty) {
      setState(() {
        points = List.from(undoStack.removeLast());
        currentStrokeIndex--;
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      points.clear();
      undoStack.clear();
      currentStrokeIndex = -1;
    });
  }

  Paint _buildPaint(Color color) {
    return Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  Color _getCurrentColor() {
    if (isRainbowMode) {
      return rainbowColors[currentColorIndex % rainbowColors.length];
    }
    return isEraser ? const Color(0xFFFFF3E0) : selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        title: Text(
          "🎨 Fun Drawing!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24.sp,
            shadows: [
              Shadow(
                blurRadius: 10.r,
                color: Colors.black26,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: undoStack.isNotEmpty ? _undo : null,
            icon: Icon(
              Icons.undo_rounded,
              color: undoStack.isNotEmpty ? Colors.white : Colors.white54,
              size: 28.sp,
            ),
            tooltip: 'Undo',
          ),
          IconButton(
            onPressed: points.isEmpty ? null : _clearCanvas,
            icon: Icon(
              Icons.cleaning_services_rounded,
              color: points.isNotEmpty ? Colors.white : Colors.white54,
              size: 28.sp,
            ),
            tooltip: 'Clear',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15.r,
                  spreadRadius: 2.r,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: GestureDetector(
                onPanStart: (details) {
                  final currentColor = _getCurrentColor();
                  setState(() {
                    points.add(
                      DrawingPoint(
                        details.localPosition,
                        _buildPaint(currentColor),
                      ),
                    );
                  });
                  if (isRainbowMode) {
                    setState(() {
                      currentColorIndex++;
                    });
                  }
                },
                onPanUpdate: (details) {
                  final currentColor = _getCurrentColor();
                  setState(() {
                    points.add(
                      DrawingPoint(
                        details.localPosition,
                        _buildPaint(currentColor),
                      ),
                    );
                  });
                  if (isRainbowMode) {
                    setState(() {
                      currentColorIndex++;
                    });
                  }
                },
                onPanEnd: (_) {
                  setState(() => points.add(null));
                  _saveState();
                },
                child: CustomPaint(
                  painter: _Painter(points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.create_rounded,
                      color: Color(0xFF1976D2),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.fiber_manual_record_rounded,
                          size: 12.sp,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Slider(
                            min: 1,
                            max: 30,
                            value: strokeWidth,
                            activeColor: const Color(0xFFFF6B6B),
                            onChanged: (val) {
                              setState(() => strokeWidth = val);
                            },
                          ),
                        ),
                        Icon(
                          Icons.fiber_manual_record_rounded,
                          size: 20.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isRainbowMode = !isRainbowMode;
                        if (isRainbowMode) {
                          isEraser = false;
                        }
                      });
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                    },
                    child: AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isRainbowMode ? _bounceAnimation.value : 1.0,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              gradient: isRainbowMode
                                  ? const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ],
                              )
                                  : null,
                              color: isRainbowMode ? null : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isRainbowMode
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                                width: 2.w,
                              ),
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEraser = !isEraser;
                        if (isEraser) {
                          isRainbowMode = false;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isEraser
                            ? Colors.orange.withValues(alpha: 0.3)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isEraser ? Colors.orange : Colors.grey.shade300,
                          width: 2.w,
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.eraser,
                        color: Colors.black87,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 80.h,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    ...colors.map(_colorDot),
                    SizedBox(width: 12.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Color: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    color: isEraser
                        ? Colors.grey.shade200
                        : isRainbowMode
                        ? Colors.white
                        : selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2.w,
                    ),
                    gradient: isRainbowMode
                        ? const LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                        Colors.green,
                        Colors.blue,
                        Colors.purple,
                      ],
                    )
                        : null,
                  ),
                ),
                SizedBox(width: 8.w),
                if (isRainbowMode)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "🌈 Rainbow",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                if (isEraser)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "🧹 Eraser",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.draw_rounded, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        "${points.where((p) => p == null).length} strokes",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorDot(Color color) {
    final isSelected = selectedColor == color && !isEraser && !isRainbowMode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          isEraser = false;
          isRainbowMode = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        width: isSelected ? 42.r : 32.r,
        height: isSelected ? 42.r : 32.r,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 3.w,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 10.r,
              spreadRadius: 2.r,
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4.r,
            ),
          ],
        ),
        child: isSelected
            ? Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 18.sp,
        )
            : null,
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final List<DrawingPoint?> points;

  _Painter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}
