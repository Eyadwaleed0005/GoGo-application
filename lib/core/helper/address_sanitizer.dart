// address_sanitizer.dart
class AddressSanitizer {
  static String sanitizeGoogleAddress(String raw) {
    var t = raw.trim();
    if (t.isEmpty) return 'موقع غير معروف';

    t = t.replaceAll(RegExp(r'\s+'), ' ');

    t = _stripPlusCodeEverywhere(t);
    t = _removeEgyptAndGovernorate(t);
    t = _removeWeirdOnlyNumbersParts(t);
    t = _dedupeParts(t);

    // نخلي العنوان مختصر ودقيق: 2-3 أجزاء كفاية للعرض
    final parts = _splitParts(t);
    final compact = parts.take(3).join('، ').trim();

    return compact.isEmpty ? 'موقع غير معروف' : compact;
  }

  static ({String line1, String line2}) toTwoLines(String sanitized) {
    final parts = _splitParts(sanitized);
    if (parts.isEmpty) return (line1: 'موقع غير معروف', line2: '');

    final line1 = parts.first;
    final line2 = parts.length >= 2 ? parts.sublist(1).take(2).join('، ') : '';
    return (line1: line1, line2: line2);
  }

  // ----------------- Helpers -----------------

  static List<String> _splitParts(String s) {
    return s
        .split(RegExp(r'[،,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static String _stripPlusCodeEverywhere(String s) {
    // يشيل Plus code في أي مكان: "4RJ3+R8J"
    var t = s.replaceAll(RegExp(r'\b[0-9A-Z]{3,}\+[0-9A-Z]{2,}\b'), '');

    // لو جاي في أول النص بأشكال مختلفة
    t = t.replaceAll(RegExp(r'^[0-9A-Z]{3,}\+?[0-9A-Z]*\s*[,، ]*\s*'), '');

    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    t = _cleanupCommas(t);
    return t;
  }

  static String _removeEgyptAndGovernorate(String s) {
    var t = s;

    t = t.replaceAll(
      RegExp(r'(جمهورية\s*مصر\s*العربية|مصر)\s*', caseSensitive: false),
      '',
    );

    t = t.replaceAll(RegExp(r'محافظة\s+\S+(\s+\S+)?'), '');

    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    t = _cleanupCommas(t);
    return t;
  }

  static String _removeWeirdOnlyNumbersParts(String s) {
    final parts = _splitParts(s);
    final filtered = parts.where((p) {
      final onlySymbols = RegExp(r'^[0-9\-\+/\\\s]+$').hasMatch(p);
      return !onlySymbols;
    }).toList();

    return filtered.join('، ').trim();
  }

  static String _dedupeParts(String s) {
    final parts = _splitParts(s);
    final seen = <String>{};
    final unique = <String>[];

    for (final p in parts) {
      if (seen.add(p)) unique.add(p);
    }

    return unique.join('، ').trim();
  }

  static String _cleanupCommas(String s) {
    var t = s;

    t = t.replaceAll(RegExp(r'\s*[،,]\s*'), '، ');
    t = t.replaceAll(RegExp(r'(،\s*){2,}'), '، ');
    t = t.replaceAll(RegExp(r'^\s*،\s*'), '');
    t = t.replaceAll(RegExp(r'\s*،\s*$'), '');

    return t.trim();
  }
}
