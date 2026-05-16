import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
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
    final size = MediaQuery.of(context).size;

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
              child: child,
            ),
          );
        },
        child: Hero(
          tag: 'pfp_${post.postId}',
          createRectTween: (begin, end) =>
              ExpressiveRectTween(begin: begin, end: end),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child:
                          //  ClipRRect(
                          // borderRadius: BorderRadius.circular(200),
                          // child:
                          MaterialShapes.pentagon(
                              color: Colors.transparent,
                              size: size.width - 120,
                              imageFit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                post.person.pfpPath,
                                // errorWidget: (context, url, error) =>
                                // const Icon(Icons.error, size: 100),
                              )),
                    ),
                    // ),
                  ),
                  // Metadata Bubbles inside the Hero so they stay on top
                  _buildMetadata(context, animation),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Animation<double> animation) {
    final size = MediaQuery.of(context).size;
    // Staggered timing for a high-end feel
    // final usernameAnim = CurvedAnimation(
    //   parent: animation,
    //   curve: const Interval(0.85, 0.97, curve: Easing.standardDecelerate),
    //   reverseCurve:
    //       const Interval(0.25, 0.35, curve: Easing.emphasizedAccelerate),
    // );
    final nameAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.9, 0.99, curve: Easing.standardDecelerate),
      reverseCurve:
          const Interval(0.20, 0.30, curve: Easing.standardAccelerate),
    );
    final followingAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.86, 0.97, curve: Easing.standardDecelerate),
      reverseCurve:
          const Interval(0.15, 0.25, curve: Easing.standardAccelerate),
    );
    final profileAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.92, 1.0, curve: Easing.standardDecelerate),
      reverseCurve:
          const Interval(0.05, 0.15, curve: Easing.standardAccelerate),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Top Left: User Info (Cascading)
        Positioned(
          top: size.height * 0.32,
          left: 20,
          child: _StaggeredBubble(
            animation: nameAnim,
            alignment: Alignment.centerRight,
            child: _Bubble(
              supportText: post.person.userName,
              text: post.person.name,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHigh,
              textColor: Theme.of(context).colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        // Bottom: Actions (Cascading)
        Positioned(
          left: 0,
          right: 0,
          bottom: size.height * 0.5 - 200,
          child: Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _StaggeredBubble(
                  animation: followingAnim,
                  alignment: Alignment.bottomCenter,
                  child: _ActionBubble(
                    label: 'Following',
                    icon: Icons.done,
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    textColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                _StaggeredBubble(
                  animation: profileAnim,
                  alignment: Alignment.bottomCenter,
                  child: _ActionBubble(
                    label: 'Profile',
                    icon: Icons.north_east,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StaggeredBubble extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;

  const _StaggeredBubble({
    required this.animation,
    required this.child,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          alignment: alignment,
          child: child,
        );
      },
      child: child,
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final String supportText;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const _Bubble({
    required this.text,
    required this.supportText,
    required this.backgroundColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(8)),
        ),
        child: Column(
          children: [
            Text(
              supportText,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
          ],
        ));
  }
}

class _UserNameBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _UserNameBubble({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(8)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
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
    return SizedBox(
        height: 64,
        child: FilledButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
          ),
          onPressed: () {},
          icon: Icon(icon, color: textColor, size: 18),
          label: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ));
  }
}
