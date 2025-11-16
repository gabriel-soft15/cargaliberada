import 'package:cargaliberada/controllers/authController.dart';
import 'package:cargaliberada/screens/productListScreen.dart';
import 'package:cargaliberada/screens/productFormScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Positioned(
            top: -80,
            child: Image.asset(
              'lib/img/logocargaliberada.png',
              height: 500,
              fit: BoxFit.contain,
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: auth.logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _HomeButton(
              icon: Icons.inventory_2_outlined,
              label: "Mercadorias para Embarque",
              onTap: () => Get.to(() => ProductListScreen()),
            ),
            _HomeButton(
              icon: Icons.add_circle_outline,
              label: "Cadastro de Mercadorias",
              onTap: () => Get.to(() => const ProductFormScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HomeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue.shade900),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
