import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Color readableOn(Color background) =>
    background.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;

Color nameColor(Color c) =>
    c.computeLuminance() > 0.8 ? Colors.grey.shade800 : c;

class AssetVisual extends StatelessWidget {
  final String asset;
  final double? height;
  final BoxFit fit;

  const AssetVisual({
    super.key,
    required this.asset,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (asset.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(asset, height: height, fit: fit);
    }
    return Image.asset(
      asset,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) =>
          const Icon(Icons.image_not_supported_rounded, size: 48),
    );
  }
}

class SegmentProgressBar extends StatelessWidget {
  final int total;
  final int current;
  final Color trackColor;

  const SegmentProgressBar({
    super.key,
    required this.total,
    required this.current,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(total, (i) {
          final active = i <= current;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: active ? Colors.amber : trackColor,
                gradient: i == current
                    ? const LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                      )
                    : null,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RoundActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final List<Color> colors;
  final double size;

  const RoundActionButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.colors,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.3),
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
              width: size,
              height: size,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreChip extends StatelessWidget {
  final String emoji;
  final String label;

  const ScoreChip({super.key, required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
