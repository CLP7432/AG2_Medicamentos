import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      print('Cargando modelo TFLite con tflite_flutter...');

      // Cargar el modelo desde assets
      _interpreter = await Interpreter.fromAsset('assets/modelo_medicamentos.tflite');

      // Cargar las etiquetas desde assets, limpiar y eliminar líneas vacías
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty) //  elimina líneas vacías
          .map((line) => line.split(' ').skip(1).join(' '))
          .toList();

      print(' MODELO TFLITE FLUTTER CARGADO EXITOSAMENTE');
      print('Clases detectadas: ${_labels.length} → $_labels');
      _isModelLoaded = true;
    } catch (e) {
      print(' ERROR cargando modelo: $e');
      _isModelLoaded = false;
    }
  }

  Future<List<Map<String, dynamic>>?> classifyImage(File imageFile) async {
    if (!_isModelLoaded) {
      await loadModel();
      if (!_isModelLoaded) return null;
    }

    try {
      print('Procesando imagen: ${imageFile.path}');

      final rawImage = imageFile.readAsBytesSync();
      final img.Image? image = img.decodeImage(rawImage);

      if (image == null) {
        print('No se pudo decodificar la imagen');
        return null;
      }

      // Ajusta el tamaño según lo que espera tu modelo (224x224 en tu caso)
      final resized = img.copyResize(image, width: 224, height: 224);

      // Convertir a tensor normalizado
      var input = List.generate(
        1,
            (_) => List.generate(
          224,
              (y) => List.generate(
            224,
                (x) {
              final pixel = resized.getPixel(x, y);
              final r = pixel.r / 255.0;
              final g = pixel.g / 255.0;
              final b = pixel.b / 255.0;
              return [r, g, b];
            },
          ),
        ),
      );

      // Crear salida con el tamaño correcto (coincide con número de labels)
      var output = List<double>.filled(_labels.length, 0).reshape([1, _labels.length]);

      // Ejecutar el modelo
      _interpreter.run(input, output);

      // Convertir resultados
      List<Map<String, dynamic>> results = [];
      for (int i = 0; i < _labels.length; i++) {
        results.add({
          'label': _labels[i],
          'confidence': output[0][i],
        });
      }

      // Ordenar por confianza
      results.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));

      // Imprimir resultados en consola
      for (var rec in results.take(5)) {
        print('${rec['label']}: ${(rec['confidence'] * 100).toStringAsFixed(2)}%');
      }

      // Siempre devolvemos las 5 mejores predicciones (aunque sean bajas)
      return results.take(5).toList();
    } catch (e) {
      print(' ERROR en classifyImage: $e');
      return null;
    }
  }

  void dispose() {
    if (_isModelLoaded) {
      _interpreter.close();
      print('Modelo TFLite liberado');
    }
  }
}
