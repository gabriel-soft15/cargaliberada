class ProductModel {
  final int? id;
  final String firestoreId;
  final String nome;
  final String? descricao;
  final double peso;
  final double valorNfe;
  final String remetenteCnpj;
  final String cidadeDestino;

  ProductModel({
    this.id,
    required this.firestoreId,
    required this.nome,
    this.descricao,
    required this.peso,
    required this.valorNfe,
    required this.remetenteCnpj,
    required this.cidadeDestino,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      firestoreId: map['firestoreId'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      descricao: map['descricao'] as String?,
      peso: (map['peso'] as num?)?.toDouble() ?? 0.0,
      valorNfe: (map['valorNfe'] as num?)?.toDouble() ?? 0.0,
      remetenteCnpj: map['remetenteCnpj'] as String? ?? '',
      cidadeDestino: map['cidadeDestino'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firestoreId': firestoreId,
      'nome': nome,
      'descricao': descricao,
      'peso': peso,
      'valorNfe': valorNfe,
      'remetenteCnpj': remetenteCnpj,
      'cidadeDestino': cidadeDestino,
    };
  }

  factory ProductModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return ProductModel(
      id: null,
      firestoreId: uid,
      nome: (data['nome'] ?? '') as String,
      descricao: (data['descricao'] ?? '') as String?,
      peso: (data['peso'] as num?)?.toDouble() ?? 0.0,
      valorNfe: (data['valorNfe'] as num?)?.toDouble() ?? 0.0,
      remetenteCnpj: (data['remetenteCnpj'] ?? '') as String,
      cidadeDestino: (data['cidadeDestino'] ?? '') as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'descricao': descricao,
      'peso': peso,
      'valorNfe': valorNfe,
      'remetenteCnpj': remetenteCnpj,
      'cidadeDestino': cidadeDestino,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  ProductModel copyWith({
    int? id,
    String? firestoreId,
    String? nome,
    String? descricao,
    double? peso,
    double? valorNfe,
    String? remetenteCnpj,
    String? cidadeDestino,
  }) {
    return ProductModel(
      id: id ?? this.id,
      firestoreId: firestoreId ?? this.firestoreId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      peso: peso ?? this.peso,
      valorNfe: valorNfe ?? this.valorNfe,
      remetenteCnpj: remetenteCnpj ?? this.remetenteCnpj,
      cidadeDestino: cidadeDestino ?? this.cidadeDestino,
    );
  }
}
