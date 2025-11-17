import 'package:cargaliberada/controllers/authController.dart';
import 'package:cargaliberada/controllers/productController.dart';
import 'package:cargaliberada/screens/checkListScreen.dart';
import 'package:cargaliberada/screens/productListScreen.dart';
import 'package:cargaliberada/screens/productFormScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final ProductController c =
        Get.find(); // <-- necessário para listar checklists

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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------
              // GRID DE BOTÕES PRINCIPAIS
              // --------------------------
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                  _HomeButton(
                    icon: Icons.checklist_rtl,
                    label: "Check List de Embarque",
                    onTap: () => Get.to(() => const ProductCheckList()),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --------------------------
              // TÍTULO DO HISTÓRICO
              // --------------------------
              const Text(
                "Checklists Realizados",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // --------------------------
              // LISTAGEM DOS CHECKLISTS
              // --------------------------
              Obx(() {
                final lista = c.products
                    .where((p) => p.situacaoChecklist != null)
                    .toList();

                if (lista.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Nenhum checklist registrado ainda.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final p = lista[i];

                    final data = DateTime.fromMillisecondsSinceEpoch(
                      p.dataChecklist ?? 0,
                    );

                    final dataFormatada =
                        "${data.day.toString().padLeft(2, '0')}/"
                        "${data.month.toString().padLeft(2, '0')}/"
                        "${data.year}";

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          size: 32,
                          color: p.situacaoChecklist == "Aprovado"
                              ? Colors.green
                              : p.situacaoChecklist == "Ajustes"
                              ? Colors.orange
                              : Colors.red,
                        ),
                        title: Text(
                          "${p.nome} – ${p.situacaoChecklist}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "Destino: ${p.cidadeDestino}\n"
                          "Data: $dataFormatada",
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
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
