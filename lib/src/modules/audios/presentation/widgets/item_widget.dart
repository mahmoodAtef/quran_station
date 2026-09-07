// lib/src/modules/audios/presentation/widgets/item_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemWidget extends StatefulWidget {
  final void Function() onPressed;
  final String title;
  final IconData? icon;
  final Widget? suffix;
  final String? subTitle;

  const ItemWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.suffix,
    this.subTitle,
  });

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    setState(() => _isPressed = value);
    value ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Material(
              elevation: _isPressed ? 1 : 4,
              shadowColor: colorScheme.shadow.withOpacity(0.15),
              borderRadius: BorderRadius.circular(5.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.w),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [colorScheme.surface, colorScheme.surface.withOpacity(0.95)]
                        : [colorScheme.surface, colorScheme.surfaceContainerHighest.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
                ),
                child: InkWell(
                  onTap: widget.onPressed,
                  onTapDown: (_) => _setPressed(true),
                  onTapUp: (_) => _setPressed(false),
                  onTapCancel: () => _setPressed(false),
                  borderRadius: BorderRadius.circular(5.w),
                  splashColor: colorScheme.primary.withOpacity(0.08),
                  highlightColor: colorScheme.primary.withOpacity(0.05),
                  child: Padding(
                    padding: EdgeInsets.all(4.5.w),
                    child: Row(
                      children: [
                        if (widget.icon != null) ...[
                          _IconBadge(icon: widget.icon!, colorScheme: colorScheme),
                          SizedBox(width: 3.5.w),
                        ],
                        Expanded(
                          child: _TextContent(
                            theme: theme,
                            colorScheme: colorScheme,
                            title: widget.title,
                            subTitle: widget.subTitle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        _TrailingSlot(colorScheme: colorScheme, suffix: widget.suffix),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final ColorScheme colorScheme;

  const _IconBadge({required this.icon, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13.w,
      height: 13.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.15),
            colorScheme.primary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
      ),
      child: Icon(icon, color: colorScheme.primary, size: 6.w),
    );
  }
}

class _TextContent extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final String title;
  final String? subTitle;

  const _TextContent({
    required this.theme,
    required this.colorScheme,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.3,
            letterSpacing: 0.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subTitle != null) ...[
          SizedBox(height: 0.7.h),
          Text(
            subTitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.65),
              height: 1.4,
              letterSpacing: 0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _TrailingSlot extends StatelessWidget {
  final ColorScheme colorScheme;
  final Widget? suffix;

  const _TrailingSlot({required this.colorScheme, required this.suffix});

  @override
  Widget build(BuildContext context) {
    if (suffix != null) {
      return Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: suffix,
      );
    }
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        color: colorScheme.primary.withOpacity(0.7),
        size: 4.w,
      ),
    );
  }
}