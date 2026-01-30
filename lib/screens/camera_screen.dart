import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:medicamentos_app/services/tflite_service.dart';
import 'details_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final TFLiteService _tfliteService = TFLiteService();
  bool _isAnalyzing = false;
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    // Cargar el modelo una vez al iniciar la pantalla
    _loadModelOnce();
  }

  Future<void> _loadModelOnce() async {
    try {
      await _tfliteService.loadModel();
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      print('Error al cargar el modelo: $e');

    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _analyzeImage() async {
    // Verificar que el modelo esté cargado antes de analizar
    if (!_isModelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El modelo no está cargado. Intente de nuevo."),
        ),
      );
      return;
    }

    if (_selectedImage != null && !_isAnalyzing) {
      setState(() {
        _isAnalyzing = true;
      });

      try {
        var results = await _tfliteService.classifyImage(_selectedImage!);

        if (results != null && results.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(
                medicamentoNombre: results[0]['label'],
                predictions: results, // AHORA SÍ EXISTE
                imageFile: _selectedImage, // AHORA SÍ EXISTE
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No se pudo identificar el medicamento"),
            ),
          );
        }
      } catch (e) {
        print('Error en análisis: $e'); // Para debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al analizar la imagen: ${e.toString()}"),
          ),
        );
      } finally {
        setState(() {
          _isAnalyzing = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Primero seleccione una imagen"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Indicador de carga del modelo
            if (!_isModelLoaded && !_isAnalyzing)
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 10),
                    Text('Cargando modelo de IA...'),
                  ],
                ),
              ),

            Expanded(
              child: _selectedImage != null
                  ? Stack(
                children: [
                  Image.file(_selectedImage!),
                  if (_isAnalyzing)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text(
                              'Analizando imagen...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
                  : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No hay imagen seleccionada',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null && _isModelLoaded)
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _isAnalyzing
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(width: 10),
                    Text('Analizando...'),
                  ],
                )
                    : const Text(
                  'Analizar Medicamento',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tfliteService.dispose();
    super.dispose();
  }
}