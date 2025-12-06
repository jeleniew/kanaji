// i_kanji_repository.dart

abstract class IKanjiRepository {
  Future<String> getSvgByKanji(String kanji);
}