import 'dart:io';
import 'package:flutter/material.dart';
import '../services/medicamentos_service.dart';

class DetailsScreen extends StatefulWidget {
  final String medicamentoNombre;
  final List<Map<String, dynamic>>? predictions;
  final File? imageFile;

  const DetailsScreen({
    super.key,
    required this.medicamentoNombre,
    this.predictions,
    this.imageFile,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Medicamento? _medicamento;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarInformacion();
  }

  Future<void> _cargarInformacion() async {
    final servicio = MedicamentosService();
    await servicio.cargarMedicamentos();

    final encontrado = servicio.buscarPorNombre(widget.medicamentoNombre);

    setState(() {
      _medicamento = encontrado;
      _cargando = false;
    });
  }

  Widget _buildImageSection() {
    if (widget.imageFile == null) return SizedBox.shrink();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📷 Imagen Escaneada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  widget.imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionsSection() {
    if (widget.predictions == null || widget.predictions!.isEmpty) {
      return SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔍 Resultados del Análisis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ...widget.predictions!.asMap().entries.map((entry) {
              final index = entry.key;
              final prediction = entry.value;
              final confidence = (prediction['confidence'] * 100);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getColorByConfidence(confidence),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(prediction['label']),
                trailing: Text(
                  '${confidence.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: LinearProgressIndicator(
                  value: confidence / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorByConfidence(confidence),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getColorByConfidence(double confidence) {
    if (confidence > 70) return Colors.green;
    if (confidence > 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Medicamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _medicamento == null
          ? _buildMedicamentoNoEncontrado()
          : _buildContenido(),
    );
  }

  Widget _buildMedicamentoNoEncontrado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Medicamento no encontrado:',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          Text(
            widget.medicamentoNombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 30),

          // Mostrar predicciones si existen
          if (widget.predictions != null && widget.predictions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildPredictionsSection(),
            ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Regresar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    final medicamento = _medicamento!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen escaneada
          _buildImageSection(),
          if (widget.imageFile != null) SizedBox(height: 15),

          // Resultados del análisis
          _buildPredictionsSection(),
          SizedBox(height: 15),

          // Título principal
          Center(
            child: Column(
              children: [
                Text(
                  medicamento.nombre.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '(${medicamento.nombreComercial})',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tarjeta de información básica
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💊 Información del Medicamento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('Dosis:', medicamento.dosis),
                  _buildInfoRow('Indicaciones:', medicamento.indicaciones),
                  _buildInfoRow('Presentación:', medicamento.presentaciones),
                  _buildInfoRow('Categoría:', medicamento.categoria),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Tarjeta de contraindicaciones
          Card(
            elevation: 3,
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚠️ Contraindicaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    medicamento.contraindicaciones,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Tarjeta de efectos secundarios
          Card(
            elevation: 3,
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💊 Efectos Secundarios',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    medicamento.efectosSecundarios,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Espacio al final
          const SizedBox(height: 30),

          // Botón para escanear otro
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Escanear Otro Medicamento'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}