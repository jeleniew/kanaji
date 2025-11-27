import 'dart:typed_data';
import 'dart:ui';

abstract class IImageProcessingService {
  // TODO: are both ...toImage methods necessary?
  Future<Image> convertPointsToImage(List<List<Offset?>> strokes, Size canvasSize);
  Future<Float32List> processImage(ByteData inputImage);
  Future<Image> float32ListToImage(Float32List input, int width, int height);
}