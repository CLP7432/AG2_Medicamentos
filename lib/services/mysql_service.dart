import 'dart:convert';
import 'package:http/http.dart' as http;

class MySQLMedicamento {
  final int id;
  final String nombre;
  final String nombreComercial;
  final String dosis;
  final String indicaciones;
  final String contraindicaciones;
  final String efectosSecundarios;
  final String presentaciones;
  final String categoria;

  MySQLMedicamento({
    required this.id,
    required this.nombre,
    required this.nombreComercial,
    required this.dosis,
    required this.indicaciones,
    required this.contraindicaciones,
    required this.efectosSecundarios,
    required this.presentaciones,
    required this.categoria,
  });

  factory MySQLMedicamento.fromJson(Map<String, dynamic> json) {
    return MySQLMedicamento(
      id: int.tryParse(json['id'].toString()) ?? 0, // FIX: convertir String a int
      nombre: json['nombre']?.toString() ?? '',
      nombreComercial: json['nombre_comercial']?.toString() ?? '',
      dosis: json['dosis']?.toString() ?? '',
      indicaciones: json['indicaciones']?.toString() ?? '',
      contraindicaciones: json['contraindicaciones']?.toString() ?? '',
      efectosSecundarios: json['efectos_secundarios']?.toString() ?? '',
      presentaciones: json['presentaciones']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
    );
  }
}

class MySQLService {
  // Cambia esta URL si tu IP es diferente
  static const String baseUrl = 'http://192.168.100.74/medicamentos_api/api.php';

  Future<List<MySQLMedicamento>> obtenerTodosMedicamentos() async {
    try {
      print(' CONECTANDO A: $baseUrl');
      final response = await http.get(Uri.parse(baseUrl));

      print(' STATUS: ${response.statusCode}');
      print(' BODY: ${response.body.substring(0, 200)}...'); // Solo primeros 200 chars

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('ÉXITO: ${jsonData.length} medicamentos');

        // Debug: mostrar primer medicamento
        if (jsonData.isNotEmpty) {
          print('🔍 Primer medicamento: ${jsonData[0]}');
        }

        return jsonData.map((item) => MySQLMedicamento.fromJson(item)).toList();
      } else {
        print(' ERROR HTTP: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(' EXCEPCIÓN: $e');
      print(' Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  Future<MySQLMedicamento?> buscarPorNombre(String nombre) async {
    try {
      final url = '$baseUrl?nombre=${Uri.encodeQueryComponent(nombre)}';
      print('🔍 BUSCANDO: $url');
      final response = await http.get(Uri.parse(url));

      print('📡 BUSQUEDA STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('🔍 RESULTADOS: ${jsonData.length}');

        if (jsonData.isNotEmpty) {
          return MySQLMedicamento.fromJson(jsonData[0]);
        }
        return null;
      } else {
        throw Exception('Error en búsqueda: ${response.statusCode}');
      }
    } catch (e) {
      print('Error buscando medicamento: $e');
      return null;
    }
  }
}