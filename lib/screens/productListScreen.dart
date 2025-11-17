import 'package:cargaliberada/controllers/productController.dart';
import 'package:cargaliberada/models/productModel.dart';
import 'package:cargaliberada/screens/productFormScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  // Usa o MESMO controller em todo o app
  final c = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercadorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => c.load(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => c.load(v),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.error.value != null) {
                return Center(child: Text(c.error.value!));
              }
              if (c.products.isEmpty) {
                return const Center(
                  child: Text('Nenhuma mercadoria encontrada.'),
                );
              }

              return ListView.separated(
                itemCount: c.products.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final ProductModel p = c.products[i];

                  return ListTile(
                    title: Text(p.nome),
                    subtitle: Text(
                      'Destino: ${p.cidadeDestino} • Peso: ${p.peso} kg | NF-e R\$ ${p.valorNfe}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () async {
                            final updated = await Get.to(
                              () => ProductFormScreen(product: p),
                            );
                            if (updated == true) c.load();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Excluir',
                          onPressed: () async {
                            if (p.id != null) {
                              await c.remove(p.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mercadoria excluída.'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Get.to(() => const ProductFormScreen());
          if (created == true) c.load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
