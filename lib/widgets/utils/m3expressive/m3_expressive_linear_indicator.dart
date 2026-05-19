// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// @docImport 'package:flutter/semantics.dart';
library;

import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const int _kIndeterminateLinearDuration = 1800;

enum ProgressIndicatorType { m3Expressive, m3 }

/// A base class for Material Design progress indicators.
///
/// This widget cannot be instantiated directly. For a linear progress
/// indicator, see [ExpressiveProgressIndicator]. For a circular progress indicator,
/// see [CircularProgressIndicator].
///
/// See also:
///
///  * <https://material.io/components/progress-indicators>
abstract class ProgressIndicator extends StatefulWidget {
  /// Creates a progress indicator.
  ///
  /// {@template flutter.material.ProgressIndicator.ProgressIndicator}
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  /// {@endtemplate}
  const ProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's background color.
  ///
  /// It is up to the subclass to implement this in whatever way makes sense
  /// for the given use case. See the subclass documentation for details.
  final Color? backgroundColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.color}
  /// The progress indicator's color.
  ///
  /// This is only used if [ProgressIndicator.valueColor] is null.
  /// If [ProgressIndicator.color] is also null, then the ambient
  /// [ProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  /// {@endtemplate}
  final Color? color;

  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [ProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  final Animation<Color?>? valueColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsValue}
  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  /// {@endtemplate}
  final String? semanticsValue;

  Color _getValueColor(BuildContext context, {Color? defaultColor}) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        defaultColor ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      PercentProperty(
        'value',
        value,
        showName: false,
        ifNull: '<indeterminate>',
      ),
    );
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class _ExpressiveProgressIndicatorPainter extends CustomPainter {
  const _ExpressiveProgressIndicatorPainter({
    required this.trackColor,
    required this.valueColor,
    this.value,
    required this.animationValue,
    required this.textDirection,
    required this.indicatorBorderRadius,
    required this.stopIndicatorColor,
    required this.stopIndicatorRadius,
    required this.trackGap,
    required this.progressIndicatorType,
    required this.userAmplitude,
    required this.userFrequency,
  });

  final Color trackColor;
  final Color valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final BorderRadiusGeometry? indicatorBorderRadius;
  final Color? stopIndicatorColor;
  final double? stopIndicatorRadius;
  final double? trackGap;
  final ProgressIndicatorType progressIndicatorType;
  final double userAmplitude;
  final double userFrequency;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final double effectiveTrackGap = switch (value) {
      null || 1.0 => 0.0,
      _ => trackGap ?? 0.0,
    };

    final Rect trackRect;
    if (value != null && effectiveTrackGap > 0) {
      final initialSpacing = value! > 0 ? effectiveTrackGap : 0;
      trackRect = switch (textDirection) {
        TextDirection.ltr => Rect.fromLTRB(
          clampDouble(value!, 0.0, 1.0) * size.width + initialSpacing,
          0,
          size.width,
          size.height,
        ),
        TextDirection.rtl => Rect.fromLTRB(
          0,
          0,
          size.width - clampDouble(value!, 0.0, 1.0) * size.width,
          size.height,
        ),
      };
    } else {
      trackRect = Offset.zero & size;
    }

    // Draw the track.
    final Paint trackPaint = Paint()..color = trackColor;
    if (indicatorBorderRadius != null) {
      final RRect trackRRect = indicatorBorderRadius!
          .resolve(textDirection)
          .toRRect(trackRect);
      canvas.drawRRect(trackRRect, trackPaint);
    } else {
      canvas.drawRect(trackRect, trackPaint);
    }

    void drawStopIndicator() {
      // Limit the stop indicator radius to the height of the indicator.
      final double radius = math.min(stopIndicatorRadius!, size.height / 2);
      final Paint indicatorPaint = Paint()..color = stopIndicatorColor!;
      final Offset position = switch (textDirection) {
        TextDirection.rtl => Offset(size.height / 2, size.height / 2),
        TextDirection.ltr => Offset(
          size.width - size.height / 2,
          size.height / 2,
        ),
      };
      canvas.drawCircle(position, radius, indicatorPaint);
    }

    // Draw the stop indicator.
    if (value != null &&
        stopIndicatorRadius != null &&
        stopIndicatorRadius! > 0) {
      drawStopIndicator();
    }

    void drawActiveIndicator(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left = switch (textDirection) {
        TextDirection.rtl => size.width - width - x,
        TextDirection.ltr => x,
      };
      final Rect activeRect = Offset(left, 0.0) & Size(width, size.height);
      final Paint activeIndicatorPaintWavy = Paint()
        ..color = valueColor
        ..strokeWidth = activeRect.height
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final Paint activeIndicatorPaintPlain = Paint()..color = valueColor;

      final double progress = value ?? 0.0;

      final path = Path();
      if (progressIndicatorType == ProgressIndicatorType.m3Expressive) {
        double smoothStep(double edge0, double edge1, double x) {
          final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
          return t * t * (3 - 2 * t);
        }

        const double fadeWidth = 0.05;
        final double fadeIn = smoothStep(0.05, 0.05 + fadeWidth, progress);
        final double fadeOut =
            1.0 - smoothStep(0.95 - fadeWidth, 0.95, progress);
        final double amplitude = userAmplitude * fadeIn * fadeOut;
        final double frequency = 2 * pi / size.width * userFrequency;
        final double verticalOffset = size.height / 2;
        final double strokeWidth = activeRect.height;
        final double leftInset = strokeWidth / 2;
        final double rightInset = width - strokeWidth / 2;

        if (width <= strokeWidth * 2) {
          if (indicatorBorderRadius != null) {
            final RRect activeRRect = indicatorBorderRadius!
                .resolve(textDirection)
                .toRRect(activeRect);
            canvas.drawRRect(activeRRect, activeIndicatorPaintPlain);
          } else {
            canvas.drawRect(activeRect, activeIndicatorPaintPlain);
          }
        } else {
          for (double dx = 0; dx <= rightInset - leftInset; dx++) {
            final double x = leftInset + dx;

            final double y =
                amplitude * sin(frequency * x + progress * 10 * pi) +
                verticalOffset;
            if (dx == 0) {
              path.moveTo(x, y);
            } else {
              path.lineTo(x, y);
            }
          }
        }

        canvas.drawPath(path, activeIndicatorPaintWavy);
      } else {
        if (indicatorBorderRadius != null) {
          final RRect activeRRect = indicatorBorderRadius!
              .resolve(textDirection)
              .toRRect(activeRect);
          canvas.drawRRect(activeRRect, activeIndicatorPaintPlain);
        } else {
          canvas.drawRect(activeRect, activeIndicatorPaintPlain);
        }
      }
    }

    // Draw the active indicator.
    if (value != null) {
      drawActiveIndicator(0.0, clampDouble(value!, 0.0, 1.0) * size.width);
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 =
          size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 =
          size.width * line2Head.transform(animationValue) - x2;

      drawActiveIndicator(x1, width1);
      drawActiveIndicator(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_ExpressiveProgressIndicatorPainter oldPainter) {
    return oldPainter.trackColor != trackColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection ||
        oldPainter.indicatorBorderRadius != indicatorBorderRadius ||
        oldPainter.stopIndicatorColor != stopIndicatorColor ||
        oldPainter.stopIndicatorRadius != stopIndicatorRadius ||
        oldPainter.trackGap != trackGap;
  }
}

/// A Material Design linear progress indicator, also known as a progress bar.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a line. There are two kinds of linear
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator line is displayed with [valueColor], an animated value. To
/// specify a constant color value use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// The minimum height of the indicator can be specified using [minHeight].
/// The indicator can be made taller by wrapping the widget with a [SizedBox].
///
/// {@tool dartpad}
/// This example showcases determinate and indeterminate [ExpressiveProgressIndicator]s.
/// The [ExpressiveProgressIndicator]s will use the ![updated Material 3 Design appearance](https://m3.material.io/components/progress-indicators/overview)
/// when setting the [ExpressiveProgressIndicator.year2023] flag to false.
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of a [ExpressiveProgressIndicator] with a changing value.
/// When toggling the switch, [ExpressiveProgressIndicator] uses a determinate value.
/// As described in: https://m3.material.io/components/progress-indicators/overview
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CircularProgressIndicator], which shows progress along a circular arc.
///  * [RefreshIndicator], which automatically displays a [CircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
class ExpressiveProgressIndicator extends ProgressIndicator {
  /// Creates a linear progress indicator.
  ///
  /// {@macro flutter.material.ProgressIndicator.ProgressIndicator}
  const ExpressiveProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    this.borderRadius,
    this.stopIndicatorColor,
    this.stopIndicatorRadius,
    this.trackGap,
    this.progressIndicatorType = ProgressIndicatorType.m3Expressive,
    this.amplitude = 10,
    this.frequency = 10,
    @Deprecated(
      'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
      'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
      'This feature was deprecated after v3.26.0-0.1.pre.',
    )
    this.year2023,
  }) : assert(minHeight == null || minHeight > 0),
       assert(
         progressIndicatorType != ProgressIndicatorType.m3Expressive ||
             frequency != 0,
         'frequency must not be 0 when progressIndicatorType is m3Expressive',
       );

  /// {@template flutter.material.LinearProgressIndicator.trackColor}
  /// Color of the track being filled by the linear indicator.
  ///
  /// If [ExpressiveProgressIndicator.backgroundColor] is null then the
  /// ambient [ProgressIndicatorThemeData.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.background]
  /// will be used to draw the track.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// {@template flutter.material.LinearProgressIndicator.minHeight}
  /// The minimum height of the line used to draw the linear indicator.
  ///
  /// If [ExpressiveProgressIndicator.minHeight] is null then it will use the
  /// ambient [ProgressIndicatorThemeData.linearMinHeight]. If that is null
  /// it will use 4dp.
  /// {@endtemplate}
  final double? minHeight;

  /// The border radius of both the indicator and the track.
  ///
  /// If null, then the [ProgressIndicatorThemeData.borderRadius] will be used.
  /// If that is also null, then defaults to radius of 2, which produces a
  /// rounded shape with a rounded indicator. If [ThemeData.useMaterial3] is false,
  /// then defaults to [BorderRadius.zero], which produces a rectangular shape
  /// with a rectangular indicator.
  final BorderRadiusGeometry? borderRadius;

  /// The color of the stop indicator.
  ///
  /// If [year2023] is false or [ThemeData.useMaterial3] is false, then no stop
  /// indicator will be drawn.
  ///
  /// If null, then the [ProgressIndicatorThemeData.stopIndicatorColor] will be used.
  /// If that is null, then the [ColorScheme.primary] will be used.
  final Color? stopIndicatorColor;

  /// The radius of the stop indicator.
  ///
  /// If [year2023] is false or [ThemeData.useMaterial3] is false, then no stop
  /// indicator will be drawn.
  ///
  /// Set [stopIndicatorRadius] to 0 to hide the stop indicator.
  ///
  /// If null, then the [ProgressIndicatorThemeData.stopIndicatorRadius] will be used.
  /// If that is null, then defaults to 2.
  final double? stopIndicatorRadius;

  /// The gap between the indicator and the track.
  ///
  /// If [year2023] is false or [ThemeData.useMaterial3] is false, then no track
  /// gap will be drawn.
  ///
  /// Set [trackGap] to 0 to hide the track gap.
  ///
  /// If null, then the [ProgressIndicatorThemeData.trackGap] will be used.
  /// If that is null, then defaults to 4.
  final double? trackGap;

  /// When true, the [ExpressiveProgressIndicator] will use the 2023 Material Design 3
  /// appearance.
  ///
  /// If null, then the [ProgressIndicatorThemeData.year2023] will be used.
  /// If that is null, then defaults to true.
  ///
  /// If this is set to false, the [ExpressiveProgressIndicator] will use the
  /// latest Material Design 3 appearance, which was introduced in December 2023.
  ///
  /// If [ThemeData.useMaterial3] is false, then this property is ignored.
  @Deprecated(
    'Set this flag to false to opt into the 2024 progress indicator appearance. Defaults to true. '
    'In the future, this flag will default to false. Use ProgressIndicatorThemeData to customize individual properties. '
    'This feature was deprecated after v3.27.0-0.1.pre.',
  )
  final bool? year2023;

  final ProgressIndicatorType progressIndicatorType;
  final double amplitude;
  final double frequency;
  @override
  State<ExpressiveProgressIndicator> createState() =>
      _ExpressiveProgressIndicatorState();
}

class _ExpressiveProgressIndicatorState
    extends State<ExpressiveProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ExpressiveProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(
    BuildContext context,
    double animationValue,
    TextDirection textDirection,
  ) {
    final ProgressIndicatorThemeData indicatorTheme = ProgressIndicatorTheme.of(
      context,
    );
    final bool year2023 = widget.year2023 ?? indicatorTheme.year2023 ?? true;
    final ProgressIndicatorThemeData defaults = switch (Theme.of(
      context,
    ).useMaterial3) {
      true =>
        year2023
            ? _LinearProgressIndicatorDefaultsM3Year2023(context)
            : _LinearProgressIndicatorDefaultsM3(context),
      false => _LinearProgressIndicatorDefaultsM2(context),
    };
    final Color trackColor =
        widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        defaults.linearTrackColor!;
    final double minHeight =
        widget.minHeight ??
        indicatorTheme.linearMinHeight ??
        defaults.linearMinHeight!;
    final BorderRadiusGeometry? borderRadius =
        widget.borderRadius ??
        indicatorTheme.borderRadius ??
        defaults.borderRadius;
    final Color? stopIndicatorColor = !year2023
        ? widget.stopIndicatorColor ??
              indicatorTheme.stopIndicatorColor ??
              defaults.stopIndicatorColor
        : null;
    final double? stopIndicatorRadius = !year2023
        ? widget.stopIndicatorRadius ??
              indicatorTheme.stopIndicatorRadius ??
              defaults.stopIndicatorRadius
        : null;
    final double? trackGap = !year2023
        ? widget.trackGap ?? indicatorTheme.trackGap ?? defaults.trackGap
        : null;

    Widget result = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: minHeight,
      ),
      child: CustomPaint(
        painter: _ExpressiveProgressIndicatorPainter(
          trackColor: trackColor,
          valueColor: widget._getValueColor(
            context,
            defaultColor: defaults.color,
          ),
          progressIndicatorType: widget.progressIndicatorType,
          userAmplitude: widget.amplitude,
          userFrequency: widget.frequency,
          value: widget.value, // may be null
          animationValue: animationValue, // ignored if widget.value is not null
          textDirection: textDirection,
          indicatorBorderRadius: borderRadius,
          stopIndicatorColor: stopIndicatorColor,
          stopIndicatorRadius: stopIndicatorRadius,
          trackGap: trackGap,
        ),
      ),
    );

    // Clip is only needed with indeterminate progress indicators
    if (borderRadius != null && widget.value == null) {
      result = ClipRRect(borderRadius: borderRadius, child: result);
    }

    return widget._buildSemanticsWrapper(context: context, child: result);
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _LinearProgressIndicatorDefaultsM2 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM2(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.background;

  @override
  double get linearMinHeight => 4.0;
}

class _LinearProgressIndicatorDefaultsM3Year2023
    extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM3Year2023(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.secondaryContainer;

  @override
  double get linearMinHeight => 4.0;
}

class _LinearProgressIndicatorDefaultsM3 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.secondaryContainer;

  @override
  double get linearMinHeight => 4.0;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(4.0 / 2);

  @override
  Color get stopIndicatorColor => _colors.primary;

  @override
  double? get stopIndicatorRadius => 4.0 / 2;

  @override
  double? get trackGap => 4.0;
}
// dart format on

// END GENERATED TOKEN PROPERTIES - ProgressIndicator
