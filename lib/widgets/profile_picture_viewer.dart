import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/models/post.dart';

class ExpressiveRectTween extends MaterialRectArcTween {
  ExpressiveRectTween({super.begin, super.end});

  @override
  Rect lerp(double t) {
    final double curvedT = Easing.emphasizedDecelerate.transform(t);
    return super.lerp(curvedT);
  }
}

class ProfilePictureViewer extends StatelessWidget {
  final Post post;
  final Animation<double> animation;

  const ProfilePictureViewer({
    super.key,
    required this.post,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final blurValue = animation.value * 15.0;

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
            child: Container(
              color: Colors.black.withValues(alpha: animation.value * 0.4),
              child: Stack(
                children: [
                  Center(child: child),
                  // Metadata Bubbles
                  _buildMetadata(context, animation),
                ],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Hero(
            tag: 'pfp_${post.postId}',
            createRectTween: (begin, end) =>
                ExpressiveRectTween(begin: begin, end: end),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                imageUrl: post.person.pfpPath,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 100),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Animation<double> animation) {
    final bubbleAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.4, 1.0, curve: Easing.emphasizedDecelerate),
    );

    return AnimatedBuilder(
      animation: bubbleAnimation,
      builder: (context, _) {
        final t = bubbleAnimation.value;
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.8 + (0.2 * t),
            child: Stack(
              children: [
                // Top Left: User Info
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bubble(
                        text: post.person.userName,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        textColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 8),
                      _Bubble(
                        text: post.person.name,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ],
                  ),
                ),
                // Bottom Right: Actions
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.3,
                  right: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ActionBubble(
                        label: 'Following',
                        icon: Icons.done,
                        backgroundColor: const Color(0xFF2D163F),
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      _ActionBubble(
                        label: 'Profile',
                        icon: Icons.north_east,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        textColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const _Bubble({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _ActionBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  const _ActionBubble({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
