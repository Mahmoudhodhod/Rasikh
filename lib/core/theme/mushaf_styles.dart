import 'package:flutter/material.dart';

@immutable
class MushafStyles extends ThemeExtension<MushafStyles> {
  final TextStyle quranTextStyle;

  const MushafStyles({required this.quranTextStyle});

  @override
  MushafStyles copyWith({TextStyle? quranTextStyle}) =>
      MushafStyles(quranTextStyle: quranTextStyle ?? this.quranTextStyle);

  @override
  MushafStyles lerp(ThemeExtension<MushafStyles>? other, double t) {
    if (other is! MushafStyles) return this;
    return MushafStyles(
      quranTextStyle: TextStyle.lerp(quranTextStyle, other.quranTextStyle, t)!,
    );
  }
}
