import 'package:flutter/material.dart';
import '../services/mysql_service.dart';

class MySQLScreen extends StatefulWidget {
  const MySQLScreen({super.key});

  @override
  State<MySQLScreen> createState() => _MySQLScreenState();
}

class _MySQLScreenState extends State<MySQLScreen> {
  final MySQLService _mysqlService = MySQLService();
  List<MySQLMedicamento> _medicamentos = [];
  bool _cargando = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarMedicamentos();
  }

  Future<void> _cargarMedicamentos() async {
    try {
      final medicamentos = await _mysqlService.obtenerTodosMedicamentos();
      setState(() {
        _medicamentos = medicamentos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _cargando = false;
      });
    }
  }

  void _verDetalles(MySQLMedicamento medicamento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _buildDetallesSheet(medicamento);
      },
    );
  }

  Widget _buildDetallesSheet(MySQLMedicamento medicamento) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              medicamento.nombre.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              '(${medicamento.nombreComercial})',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Divider(height: 30),

          _buildInfoItem('💊 Dosis:', medicamento.dosis),
          _buildInfoItem('📋 Indicaciones:', medicamento.indicaciones),
          _buildInfoItem('⚠️ Contraindicaciones:', medicamento.contraindicaciones),
          _buildInfoItem('🔬 Efectos Secundarios:', medicamento.efectosSecundarios),
          _buildInfoItem('📦 Presentación:', medicamento.presentaciones),
          _buildInfoItem('🏷️ Categoría:', medicamento.categoria),

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String titulo, String contenido) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            contenido,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicamentoCard(MySQLMedicamento medicamento) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.medical_services, color: Colors.blue),
        title: Text(
          medicamento.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(medicamento.nombreComercial),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _verDetalles(medicamento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos - MySQL'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : _medicamentos.isEmpty
          ? const Center(child: Text('No hay medicamentos'))
          : RefreshIndicator(
        onRefresh: _cargarMedicamentos,
        child: ListView.builder(
          itemCount: _medicamentos.length,
          itemBuilder: (context, index) {
            return _buildMedicamentoCard(_medicamentos[index]);
          },
        ),
      ),
    );
  }
}