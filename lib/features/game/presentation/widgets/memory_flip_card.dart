import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/memory_card.dart';
import 'pair_face_mapper.dart';

/// Одна карта на поле: FlipCard изолирован, flipOnTouch=false — логика в Notifier.
class MemoryFlipCard extends StatefulWidget {
  const MemoryFlipCard({
    super.key,
    required this.card,
    required this.mapper,
    required this.onTap,
    required this.enabled,
  });

  final MemoryCard card;
  final PairFaceMapper mapper;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<MemoryFlipCard> createState() => _MemoryFlipCardState();
}

class _MemoryFlipCardState extends State<MemoryFlipCard> {
  final FlipCardController _controller = FlipCardController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.card.isFaceUp) {
        _controller.toggleCardWithoutAnimation();
      }
    });
  }

  @override
  void didUpdateWidget(MemoryFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.isFaceUp != widget.card.isFaceUp) {
      _controller.toggleCard();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = widget.mapper.labelFor(widget.card.pairId);
    final faceColor = widget.mapper.colorFor(widget.card.pairId, scheme);

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.card.isFaceUp || widget.card.isMatched
          ? 'Карта $label'
          : 'Закрытая карта',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: FlipCard(
            key: ValueKey('flip_${widget.card.id}'),
            controller: _controller,
            flipOnTouch: false,
            direction: FlipDirection.HORIZONTAL,
            front: _CardSide(
              background: scheme.primaryContainer,
              child: Icon(
                Icons.question_mark_rounded,
                size: 36,
                color: scheme.onPrimaryContainer,
              ),
            ),
            back: _CardSide(
              background: faceColor.withValues(alpha: 0.25),
              child: _FaceContent(
                pairId: widget.card.pairId,
                mapper: widget.mapper,
                label: label,
                iconColor: faceColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardSide extends StatelessWidget {
  const _CardSide({
    required this.background,
    required this.child,
  });

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _FaceContent extends StatelessWidget {
  const _FaceContent({
    required this.pairId,
    required this.mapper,
    required this.label,
    required this.iconColor,
  });

  final String pairId;
  final PairFaceMapper mapper;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final assetPath = mapper.assetPathFor(pairId);
    if (assetPath != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            mapper.iconFor(pairId),
            size: 40,
            color: iconColor,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(mapper.iconFor(pairId), size: 40, color: iconColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
