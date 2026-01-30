import 'dart:convert';
import 'package:flutter/services.dart';

class Medicamento {
  final String nombre;
  final String nombreComercial;
  final String dosis;
  final String indicaciones;
  final String contraindicaciones;
  final String efectosSecundarios;
  final String presentaciones;
  final String categoria;

  Medicamento({
    required this.nombre,
    required this.nombreComercial,
    required this.dosis,
    required this.indicaciones,
    required this.contraindicaciones,
    required this.efectosSecundarios,
    required this.presentaciones,
    required this.categoria,
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      nombre: json['nombre'] ?? '',
      nombreComercial: json['nombre_comercial'] ?? '',
      dosis: json['dosis'] ?? '',
      indicaciones: json['indicaciones'] ?? '',
      contraindicaciones: json['contraindicaciones'] ?? '',
      efectosSecundarios: json['efectos_secundarios'] ?? '',
      presentaciones: json['presentaciones'] ?? '',
      categoria: json['categoria'] ?? '',
    );
  }
}

class MedicamentosService {
  List<Medicamento> _medicamentos = [];

  Future<void> cargarMedicamentos() async {
    try {
      final String data = await rootBundle.loadString('assets/medicamentos.json');
      final Map<String, dynamic> jsonData = json.decode(data);

      _medicamentos = (jsonData['medicamentos'] as List)
          .map((item) => Medicamento.fromJson(item))
          .toList();

      print(' JSON cargado correctamente. ${_medicamentos.length} medicamentos.');
    } catch (e) {
      print(' Error cargando JSON: $e');
      _medicamentos = [];
    }
  }

  Medicamento? buscarPorNombre(String nombre) {
    // Buscar por nombre exacto
    for (var medicamento in _medicamentos) {
      if (medicamento.nombre.toLowerCase() == nombre.toLowerCase()) {
        return medicamento;
      }
    }

    // Si no encuentra, buscar por nombre comercial
    for (var medicamento in _medicamentos) {
      if (medicamento.nombreComercial.toLowerCase().contains(nombre.toLowerCase())) {
        return medicamento;
      }
    }

    return null;
  }

  List<Medicamento> get todosMedicamentos => _medicamentos;

  bool get estaCargado => _medicamentos.isNotEmpty;
}