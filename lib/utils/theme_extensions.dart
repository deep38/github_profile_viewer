import 'package:flutter/material.dart';

class ShimmerEffectThemeExtension
    extends ThemeExtension<ShimmerEffectThemeExtension> {
  ShimmerEffectThemeExtension({
    required this.baseColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color highlightColor;
  @override
  ThemeExtension<ShimmerEffectThemeExtension> copyWith({
    Color? baseColor,
    Color? highlightColor,
  }) {
    return ShimmerEffectThemeExtension(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ThemeExtension<ShimmerEffectThemeExtension> lerp(
    covariant ThemeExtension<ShimmerEffectThemeExtension>? other,
    double t,
  ) {
    return other is ShimmerEffectThemeExtension
        ? ShimmerEffectThemeExtension(
            baseColor: Color.lerp(baseColor, other.baseColor, t) ?? baseColor,
            highlightColor:
                Color.lerp(highlightColor, other.highlightColor, t) ??
                highlightColor,
          )
        : this;
  }
}
