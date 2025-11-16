import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cargaliberada/models/productModel.dart';
import 'package:cargaliberada/repository/productRepository.dart';

class ProductController extends GetxController {
  final _repo = ProductRepository();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load([String? q]) async {
    try {
      isLoading.value = true;
      if (kIsWeb) {
        products.value = await _repo.getAllFirestore();
      } else {
        products.value = await _repo.getAllLocal();
      }
    } catch (e) {
      error.value = 'Erro ao carregar produtos: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> create({
    required String nome,
    String? descricao,
    required double peso,
    required double valorNfe,
    required String remetenteCnpj,
    required String cidadeDestino,
  }) async {
    try {
      isLoading.value = true;
      final fid = DateTime.now().millisecondsSinceEpoch.toString();
      final p = ProductModel(
        id: null,
        firestoreId: fid,
        nome: nome,
        descricao: descricao,
        peso: peso,
        valorNfe: valorNfe,
        remetenteCnpj: remetenteCnpj,
        cidadeDestino: cidadeDestino,
      );

      if (kIsWeb) {
        await _repo.upsertFirestore(p);
      } else {
        await _repo.insertLocal(p);
        await _repo.upsertFirestore(p);
      }
      await load();
      return true;
    } catch (e) {
      error.value = 'Erro ao criar produto: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProduct(ProductModel p) async {
    try {
      isLoading.value = true;
      await _repo.upsertFirestore(p);
      if (!kIsWeb) await _repo.updateLocal(p);
      await load();
      return true;
    } catch (e) {
      error.value = 'Erro ao atualizar produto: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> remove(int id) async {
    try {
      isLoading.value = true;
      final p = products.firstWhereOrNull((e) => e.id == id);
      if (p == null) return false;
      await _repo.deleteFromFirestore(p.firestoreId);
      if (!kIsWeb) await _repo.deleteLocal(id);
      await load();
      return true;
    } catch (e) {
      error.value = 'Erro ao excluir produto: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String? validate({required String name}) {
    if (name.trim().isEmpty) return "Nome obrigatório.";
    return null;
  }
}
