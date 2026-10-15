import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/core/progress_provider.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/module_widgets.dart';
import 'package:provider/provider.dart';

/// Generic "learn" screen: one big card, name, optional sound, previous/next.
class LearnView extends StatefulWidget {
  final ModuleConfig config;
  final List<LearnItem> items;

  const LearnView({super.key, required this.config, required this.items});

  @override
  State<LearnView> createState() => _LearnViewState();
}

class _LearnViewState extends State<LearnView>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  ModuleConfig get _config => widget.config;
  List<LearnItem> get _items => widget.items;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markViewed());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _markViewed() {
    if (!mounted || _items.isEmpty) return;
    context
        .read<ProgressProvider>()
        .markViewed(_config.id, _index, _items.length);
  }

  void _go(int delta) {
    if (_items.isEmpty) return;
    setState(() {
      _index = (_index + delta + _items.length) % _items.length;
    });
    _controller.forward(from: 0);
    _markViewed();
    _speak();
  }

  void _speak() => AppAudio.instance.speak(_items[_index].spoken);

  void _onDragEnd(DragEndDetails details) {
    final v = details.primaryVelocity;
    if (v == null) return;
    if (v < 0) {
      _go(1);
    } else if (v > 0) {
      _go(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    final item = _items[_index];
    final track = _config.dark
        ? Colors.white.withValues(alpha: 0.3)
        : Colors.grey.shade200;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight =
            (constraints.maxHeight - 290).clamp(220.0, 440.0).toDouble();
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SegmentProgressBar(
                total: _items.length,
                current: _index,
                trackColor: track,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: cardHeight,
                child: GestureDetector(
                  onTap: _speak,
                  onHorizontalDragEnd: _onDragEnd,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Transform.scale(
                      scale: _scale.value,
                      child: Transform.rotate(
                        angle: _rotation.value,
                        child: child,
                      ),
                    ),
                    child: ItemCard(
                      item: item,
                      config: _config,
                      borderWidth: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _infoPanel(item),
              const SizedBox(height: 16),
              _buttons(item),
              const SizedBox(height: 8),
              Text(
                _config.swipeHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _config.hintColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoPanel(LearnItem item) {
    final color = nameColor(item.color);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: item.color.withValues(alpha: 0.3),
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
              if (item.emoji != null && item.imageAsset != null) ...[
                Text(item.emoji!, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (item.description != null) ...[
            const SizedBox(height: 6),
            Text(
              item.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            _config.tapHint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons(LearnItem item) {
    Widget emoji(String e) => Text(e, style: const TextStyle(fontSize: 28));
    final children = <Widget>[
      RoundActionButton(
        colors: _config.accent,
        onTap: () => _go(-1),
        child: emoji('👈'),
      ),
      RoundActionButton(
        colors: _config.accent,
        onTap: _speak,
        child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 32),
      ),
      if (item.soundAsset != null)
        RoundActionButton(
          colors: const [Colors.green, Colors.lightGreen],
          onTap: () => AppAudio.instance.playAsset(item.soundAsset!),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      RoundActionButton(
        colors: _config.accent,
        onTap: () => _go(1),
        child: emoji('👉'),
      ),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: children,
    );
  }
}

/// The big rounded card (picture or colour + emoji/number).
/// Also used as the question card in quiz mode.
class ItemCard extends StatelessWidget {
  final LearnItem item;
  final ModuleConfig config;
  final double borderWidth;
  final Color? borderColor;
  final bool showEmoji;

  const ItemCard({
    super.key,
    required this.item,
    required this.config,
    this.borderWidth = 4,
    this.borderColor,
    this.showEmoji = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.color;
    final decorColor = item.solid
        ? readableOn(color).withValues(alpha: 0.3)
        : Colors.white.withValues(alpha: 0.5);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: item.solid ? color : null,
        gradient: item.solid
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.5),
                  Colors.white,
                ],
              ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.8),
          width: borderWidth,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              config.decorTop,
              style: TextStyle(fontSize: 30, color: decorColor),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              config.decorBottom,
              style: TextStyle(fontSize: 30, color: decorColor),
            ),
          ),
          Center(child: _content(context)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (item.imageAsset != null) {
      return LayoutBuilder(
        builder: (context, c) {
          final h = min(config.imageHeight, max(60.0, c.maxHeight - 40));
          return Padding(
            padding: const EdgeInsets.all(20),
            child: AssetVisual(asset: item.imageAsset!, height: h),
          );
        },
      );
    }

    final textColor = item.solid ? readableOn(item.color) : nameColor(item.color);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showEmoji && item.emoji != null)
            Text(
              item.emoji!,
              style: const TextStyle(
                fontSize: 70,
                shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.black26,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          if (item.bigText != null)
            Text(
              item.bigText!,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }
}
