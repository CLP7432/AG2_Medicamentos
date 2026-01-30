import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'mysql_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _mostrarImagenesDataset(BuildContext context) {
    // Datos fijos que ya conoces
    String mensaje = 'Dataset de entrenamiento:\n\n';
    mensaje += 'amoxicilina: 317 imagenes\n';
    mensaje += 'atorvastatina: 306 imagenes\n';
    mensaje += 'diazepam: 302 imagenes\n';
    mensaje += 'diclofenaco: 286 imagenes\n';
    mensaje += 'ibuprofeno: 287 imagenes\n';
    mensaje += 'loratadina: 303 imagenes\n';
    mensaje += 'metformina: 300 imagenes\n';
    mensaje += 'omeprazol: 297 imagenes\n';
    mensaje += 'paracetamol: 445 imagenes\n';
    mensaje += 'salbutamol: 301 imagenes\n';
    mensaje += '\nTotal: 3144 imagenes';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dataset de Medicamentos'),
        content: SingleChildScrollView(
          child: Text(mensaje),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediScan - Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a MediScan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Reconocimiento de medicamentos con IA'),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                _mostrarImagenesDataset(context);
              },
              icon: const Icon(Icons.image_search),
              label: const Text('Ver Dataset de Imagenes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Escanear Medicamento'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MySQLScreen()),
                );
              },
              icon: const Icon(Icons.storage),
              label: const Text('Version con Base de Datos'),
            ),
          ],
        ),
      ),
    );
  }
}