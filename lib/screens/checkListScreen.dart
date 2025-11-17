import 'package:cargaliberada/controllers/productController.dart';
import 'package:cargaliberada/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCheckList extends StatefulWidget {
  const ProductCheckList({super.key});

  @override
  State<ProductCheckList> createState() => _ProductCheckListState();
}

class _ProductCheckListState extends State<ProductCheckList> {
  final c = Get.find<ProductController>();

  ProductModel? selectedProduct;

  final nameCtrl = TextEditingController();
  final cnpjCtrl = TextEditingController();
  final cidadeCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final itemCtrl = TextEditingController(); // Item transportado (do cadastro)

  final situacaoCtrl = TextEditingController(); // Aprovado/Ajustes/Recusado
  final recomendacaoCtrl =
      TextEditingController(); // Recomendações do checklist

  void preencherCampos(ProductModel p) {
    nameCtrl.text = p.nome;
    cnpjCtrl.text = p.remetenteCnpj;
    cidadeCtrl.text = p.cidadeDestino;
    pesoCtrl.text = p.peso.toString();

    itemCtrl.text = p.descricao ?? ""; // Item transportado
    situacaoCtrl.text = ""; // Começa vazio
    recomendacaoCtrl.text = ""; // Começa vazio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check List de Embarque")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final produtos = c.products;

          return ListView(
            children: [
              Center(
                child: Image.asset(
                  'lib/img/logocargaliberada.png',
                  height: 160,
                ),
              ),

              const SizedBox(height: 20),

              // =============================
              // COMBOBOX PARA ESCOLHER PRODUTO
              // =============================
              DropdownButtonFormField<ProductModel>(
                value: selectedProduct,
                decoration: const InputDecoration(
                  labelText: "Selecionar Mercadoria *",
                  border: OutlineInputBorder(),
                ),
                items: produtos.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text("${p.nome} • ${p.cidadeDestino} • ${p.peso}kg"),
                  );
                }).toList(),
                onChanged: (p) {
                  setState(() {
                    selectedProduct = p;
                    if (p != null) preencherCampos(p);
                  });
                },
              ),

              const SizedBox(height: 20),

              // =============================
              // CAMPOS AUTOMÁTICOS DA MERCADORIA
              // =============================
              TextField(
                controller: nameCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Remetente"),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: cnpjCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "CNPJ"),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: cidadeCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Cidade Destino"),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: pesoCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Peso (Kg)"),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: itemCtrl,
                readOnly: true,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Item a ser transportado",
                ),
              ),

              // =============================
              // DADOS DO CHECKLIST
              // =============================
              const SizedBox(height: 18),
              TextField(
                controller: situacaoCtrl,
                decoration: const InputDecoration(
                  labelText: "Situação (Aprovado / Ajustes / Recusado) *",
                ),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: recomendacaoCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Recomendações (Opcional)",
                ),
              ),

              const SizedBox(height: 25),

              // =============================
              // BOTÃO SALVAR CHECKLIST
              // =============================
              Obx(() {
                return ElevatedButton(
                  onPressed: c.isLoading.value
                      ? null
                      : () async {
                          if (selectedProduct == null) {
                            Get.snackbar(
                              "Erro",
                              "Selecione uma mercadoria.",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          final p = selectedProduct!;

                          // SALVA O CHECKLIST
                          final updated = p.copyWith(
                            situacaoChecklist: situacaoCtrl.text.trim(),
                            recomendacaoChecklist:
                                recomendacaoCtrl.text.trim().isEmpty
                                ? null
                                : recomendacaoCtrl.text.trim(),
                            dataChecklist:
                                DateTime.now().millisecondsSinceEpoch,
                          );

                          final ok = await c.updateProduct(updated);

                          if (ok && mounted) {
                            Get.snackbar(
                              "Checklist salvo",
                              "O checklist foi registrado com sucesso.",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            Navigator.pop(context, true);
                          }
                        },
                  child: const Text("Finalizar CheckList"),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
