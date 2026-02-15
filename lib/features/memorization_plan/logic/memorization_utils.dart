import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MemorizationUtils {
  static String normalizeText(String text) {
    if (text.isEmpty) return '';

    String cleaned = text.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
      '',
    );

    cleaned = cleaned.replaceAll(RegExp(r'[^\u0621-\u064A\u0671 ]'), '');

    cleaned = cleaned.replaceAll(RegExp(r'[أإآٱ]'), 'ا');

    cleaned = cleaned.replaceAll('ى', 'ي');

    cleaned = cleaned.replaceAll(RegExp(r'ء(?=ا|$)'), '');

    return cleaned.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isArabicLetter(String char) {
    const arabicLetters = 'ءأآؤإئابةتثجحخدذرزسشصضطظعغفقكلمنهوىيٱ';
    return arabicLetters.contains(char);
  }

  static bool _isAlef(String char) => 'اأآإٱ'.contains(char);

  static String _simplifyChar(String char) {
    if (_isAlef(char)) return 'ا';
    if (char == 'ى') return 'ي';
    return char;
  }

  static bool _isFollowedByAlef(String text, int currentIndex) {
    for (int i = currentIndex + 1; i < text.length; i++) {
      String nextChar = text[i];
      if (isArabicLetter(nextChar)) return _isAlef(nextChar);
      if (nextChar == ' ' || nextChar == '﴾') return false;
    }
    return false;
  }

  static List<InlineSpan> buildVerseSpans(
    String fullVerseText,
    String userInputRaw,
  ) {
    final String userInput = userInputRaw.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
      '',
    );

    final List<InlineSpan> spans = [];
    int uIdx = 0;
    Color lastColor = TColors.textPrimary;
    bool hasRequiredSpaceForCurrentGap = false;

    for (int qIdx = 0; qIdx < fullVerseText.length; qIdx++) {
      final String qChar = fullVerseText[qIdx];
      bool isLetter = isArabicLetter(qChar);
      bool isSpace = qChar == ' ';
      bool isComparable = false;

      if (isLetter) {
        isComparable = true;
        hasRequiredSpaceForCurrentGap = false;
      } else if (isSpace && !hasRequiredSpaceForCurrentGap) {
        isComparable = true;
        hasRequiredSpaceForCurrentGap = true;
      }

      Color currentColor = TColors.textPrimary;

      if (isComparable) {
        if (uIdx < userInput.length) {
          final String uChar = userInput[uIdx];

          if (qChar == 'ء' && _isFollowedByAlef(fullVerseText, qIdx)) {
            if (uChar == 'ء') {
              currentColor = Colors.green;
              uIdx++;
            } else if (_simplifyChar(uChar) == 'ا') {
              currentColor = Colors.green;
            } else {
              currentColor = Colors.red;
              uIdx++;
            }
          } else {
            bool isMatch = isSpace
                ? uChar == ' '
                : _simplifyChar(qChar) == _simplifyChar(uChar);

            currentColor = isMatch ? Colors.green : Colors.red;
            uIdx++;
          }
        }
        lastColor = currentColor;
      } else {
        currentColor = lastColor;
      }

      spans.add(
        TextSpan(
          text: qChar,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            height: 2.2,
            color: currentColor,
          ),
        ),
      );
    }
    return spans;
  }

  static int calculateCorrectSequenceLength(
    List<String> typedWords,
    List<String> fullVerseWords,
  ) {
    int correctCount = 0;
    int verseWordIndex = 0;
    for (int i = 0; i < typedWords.length; i++) {
      while (verseWordIndex < fullVerseWords.length &&
          normalizeText(fullVerseWords[verseWordIndex]).isEmpty) {
        verseWordIndex++;
      }
      if (verseWordIndex >= fullVerseWords.length) break;
      if (normalizeText(typedWords[i]) ==
          normalizeText(fullVerseWords[verseWordIndex])) {
        correctCount++;
        verseWordIndex++;
      } else {
        break;
      }
    }
    return correctCount;
  }


  static double calculateSimilarity(String target, String input) {
    if (target.isEmpty) return 0.0;
    String cleanTarget = normalizeText(target);
    String cleanInput = normalizeText(input);

    List<String> targetWords = cleanTarget.split(' ');
    List<String> inputWords = cleanInput.split(' ');

    int matches = 0;
    int length = targetWords.length;

    for (int i = 0; i < length; i++) {
      if (i < inputWords.length && targetWords[i] == inputWords[i]) {
        matches++;
      }
    }
    return matches / length;
  }

  static List<Map<String, dynamic>> getMistakes(String target, String input) {
    List<Map<String, dynamic>> mistakes = [];

    List<String> originalTargetWords = target.split(' ');

    List<String> targetWords = normalizeText(target).split(' ');
    List<String> inputWords = normalizeText(input).split(' ');

    int originalIndex = 0;

    for (int i = 0; i < targetWords.length; i++) {
      while (originalIndex < originalTargetWords.length &&
          normalizeText(originalTargetWords[originalIndex]).isEmpty) {
        originalIndex++;
      }

      String tWord = targetWords[i];
      String? iWord = i < inputWords.length ? inputWords[i] : null;
      String originalWord = originalIndex < originalTargetWords.length
          ? originalTargetWords[originalIndex]
          : tWord;

      if (iWord == null || tWord != iWord) {
        mistakes.add({
          'index': i,
          'expected': originalWord,
          'normalized_expected': tWord,
          'actual': iWord ?? '',
        });
      }
      originalIndex++;
    }
    return mistakes;
  }

  static List<String> getDetailedCharacters(String word) {
    String cleaned = word.replaceAll(
      RegExp(r'[\u064B-\u0653\u0656-\u065F\u0670\u06D6-\u06ED]'),
      '',
    );

    List<String> chars = [];
    for (int i = 0; i < cleaned.length; i++) {
      String char = cleaned[i];

      if (char == 'آ') {
        chars.add('ء');
        chars.add('ا');
      }
      else if (char == 'ٱ') {
        chars.add('ا');
      }
      else if (char == '\u0654') {
        if (chars.isNotEmpty) {
          String base = chars.last;
          if (base == 'ا') {
            chars[chars.length - 1] = 'أ';
          } else if (base == 'و') {
            chars[chars.length - 1] = 'ؤ';
          } else if (base == 'ى' || base == 'ي') {
            chars[chars.length - 1] = 'ئ';
          } else {
            chars.add('ء');
          }
        } else {
          chars.add('ء');
        }
      }
      else if (char == '\u0655') {
        if (chars.isNotEmpty && chars.last == 'ا') {
          chars[chars.length - 1] = 'إ';
        } else {
          chars.add('ء');
        }
      }
      else if (isArabicLetter(char)) {
        chars.add(char);
      }
    }
    return chars;
  }

  static String normalizeForVerification(String text) {
    return getDetailedCharacters(text).join('');
  }
}
