import 'package:cargaliberada/controllers/productController.dart';
import 'package:cargaliberada/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
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
    final p = widget.product;
    if (p != null) {
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

  bool validate() {
    if (nameCtrl.text.trim().isEmpty) {
      Get.snackbar('Erro', 'Nome obrigatório.');
      return false;
    }
    if (cnpjCtrl.text.trim().isEmpty) {
      Get.snackbar('Erro', 'CNPJ obrigatório.');
      return false;
    }
    if (cidadeCtrl.text.trim().isEmpty) {
      Get.snackbar('Erro', 'Cidade destino obrigatória.');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Mercadoria' : 'Cadastro de Mercadoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Image.asset('lib/img/logocargaliberada.png', height: 180),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome Remetente *'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: cnpjCtrl,
              decoration: const InputDecoration(labelText: 'CNPJ Remetente *'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: cidadeCtrl,
              decoration: const InputDecoration(labelText: 'Cidade Destino *'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: pesoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Peso (Kg) *'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: valorCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor NF-e (R\$) *',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Item a ser transportado',
              ),
            ),
            const SizedBox(height: 24),

            Obx(
              () => ElevatedButton(
                onPressed: c.isLoading.value
                    ? null
                    : () async {
                        if (!validate()) return;

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
                            nome: nameCtrl.text.trim(),
                            descricao: descCtrl.text.trim().isEmpty
                                ? null
                                : descCtrl.text.trim(),
                            peso: peso,
                            valorNfe: valor,
                            remetenteCnpj: cnpjCtrl.text.trim(),
                            cidadeDestino: cidadeCtrl.text.trim(),
                            updatedAt: DateTime.now().millisecondsSinceEpoch,
                            dirty: true,
                          );

                          final ok = await c.updateProduct(updated);
                          if (ok && mounted) Navigator.pop(context, true);
                        } else {
                          final ok = await c.create(
                            nome: nameCtrl.text.trim(),
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
                child: c.isLoading.value
                    ? const CircularProgressIndicator()
                    : Text(isEdit ? 'Salvar' : 'Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
