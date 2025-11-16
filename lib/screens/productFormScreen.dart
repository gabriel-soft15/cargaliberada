import 'package:cargaliberada/controllers/productController.dart';
import 'package:cargaliberada/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;
  // O construtor continua 'const', o que é bom
  const ProductFormScreen({super.key, this.product});

  // A linha "final ProductController controller = Get.put(ProductController());"
  // foi REMOVIDA daqui.

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  // O Get.put() foi MOVIDO para cá, que é o lugar correto.
  final c = Get.put(ProductController());

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final valorCtrl = TextEditingController();
  final cnpjCtrl = TextEditingController();
  final cidadeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      final p = widget.product!;
      nameCtrl.text = p.nome;
      descCtrl.text = p.descricao ?? '';
      pesoCtrl.text = p.peso.toString();
      valorCtrl.text = p.valorNfe.toString();
      cnpjCtrl.text = p.remetenteCnpj;
      cidadeCtrl.text = p.cidadeDestino;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    pesoCtrl.dispose();
    valorCtrl.dispose();
    cnpjCtrl.dispose();
    cidadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Editar Produto" : "Cadastro de Mercadoria"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Positioned(
              top: -10,
              child: Image.asset(
                'lib/img/logocargaliberada.png',
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nome Remetente *"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cnpjCtrl,
              decoration: const InputDecoration(labelText: "CNPJ Remetente *"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cidadeCtrl,
              decoration: const InputDecoration(labelText: "Cidade Destino *"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pesoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Peso (Kg) *"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valorCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                // CORRIGIDO: Adicionado \ antes do $
                labelText: "Valor NF-e (R\$) *",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Descrição (Opcional)",
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return ElevatedButton(
                // CORRIGIDO: Voltamos a usar "c"
                onPressed: c.isLoading.value
                    ? null
                    : () async {
                        final nome = nameCtrl.text.trim();
                        final peso =
                            double.tryParse(
                              pesoCtrl.text.replaceAll(',', '.'),
                            ) ??
                            0.0;
                        final valor =
                            double.tryParse(
                              valorCtrl.text.replaceAll(',', '.'),
                            ) ??
                            0.0;
                        if (isEdit) {
                          final updated = widget.product!.copyWith(
                            nome: nome,
                            descricao: descCtrl.text.trim().isEmpty
                                ? null
                                : descCtrl.text.trim(),
                            peso: peso,
                            valorNfe: valor,
                            remetenteCnpj: cnpjCtrl.text.trim(),
                            cidadeDestino: cidadeCtrl.text.trim(),
                          );
                          // CORRIGIDO: Voltamos a usar "c"
                          final ok = await c.updateProduct(updated);
                          if (ok && mounted) Navigator.pop(context, true);
                        } else {
                          // CORRIGIDO: Voltamos a usar "c"
                          final ok = await c.create(
                            nome: nome,
                            descricao: descCtrl.text.trim().isEmpty
                                ? null
                                : descCtrl.text.trim(),
                            peso: peso,
                            valorNfe: valor,
                            remetenteCnpj: cnpjCtrl.text.trim(),
                            cidadeDestino: cidadeCtrl.text.trim(),
                          );
                          if (ok && mounted) Navigator.pop(context, true);
                        }
                      },
                child: Text(isEdit ? "Salvar" : "Cadastrar"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
