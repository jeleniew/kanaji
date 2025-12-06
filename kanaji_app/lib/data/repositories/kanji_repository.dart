// kanji_repository.dart

import 'package:flutter/services.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';

class KanjiRepository implements IKanjiRepository {
  @override
  Future<String> getSvgByKanji(String kanji) async {
    String kanjiCode = _getKanjiCode(kanji);
    String assetPath = 'assets/kanji_svgs/$kanjiCode.svg';

    try {
      String svgData = await rootBundle.loadString(assetPath);
      return Future.value(svgData);
    } catch (e) {
      print(e);
      return Future.error('SVG not found for kanji: $kanji');
    }
  }

  String _getKanjiCode(String kanji) {
    return kanji.codeUnits
        .map((unit) => '0${unit.toRadixString(16).padLeft(4, '0')}')
        .join();
  }
}