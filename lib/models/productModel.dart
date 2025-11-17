class ProductModel {
  final int? id; // ID local (SQLite)
  final String firestoreId; // ID no Firestore
  final String nome;
  final String? descricao; // Item transportado
  final double peso;
  final double valorNfe;
  final String remetenteCnpj;
  final String cidadeDestino;

  // CHECKLIST
  final String? situacaoChecklist;
  final String? recomendacaoChecklist;
  final int? dataChecklist;

  // USUÁRIO DONO DO CADASTRO
  final String? createdBy;

  final int updatedAt;
  final bool deleted;
  final bool dirty;

  ProductModel({
    this.id,
    required this.firestoreId,
    required this.nome,
    this.descricao,
    required this.peso,
    required this.valorNfe,
    required this.remetenteCnpj,
    required this.cidadeDestino,
    this.situacaoChecklist,
    this.recomendacaoChecklist,
    this.dataChecklist,
    this.createdBy,
    this.updatedAt = 0,
    this.deleted = false,
    this.dirty = false,
  });

  // FROM LOCAL SQLITE
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      firestoreId: map['firestoreId'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      peso: (map['peso'] as num?)?.toDouble() ?? 0.0,
      valorNfe: (map['valorNfe'] as num?)?.toDouble() ?? 0.0,
      remetenteCnpj: map['remetenteCnpj'] ?? '',
      cidadeDestino: map['cidadeDestino'] ?? '',
      situacaoChecklist: map['situacaoChecklist'],
      recomendacaoChecklist: map['recomendacaoChecklist'],
      dataChecklist: map['dataChecklist'],
      createdBy: map['createdBy'],
      updatedAt: map['updatedAt'] ?? 0,
      deleted: (map['deleted'] ?? 0) == 1,
      dirty: (map['dirty'] ?? 0) == 1,
    );
  }

  // TO LOCAL SQLITE
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
      'situacaoChecklist': situacaoChecklist,
      'recomendacaoChecklist': recomendacaoChecklist,
      'dataChecklist': dataChecklist,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'deleted': deleted ? 1 : 0,
      'dirty': dirty ? 1 : 0,
    };
  }

  // FROM FIRESTORE
  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: null,
      firestoreId: id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'],
      peso: (data['peso'] as num?)?.toDouble() ?? 0.0,
      valorNfe: (data['valorNfe'] as num?)?.toDouble() ?? 0.0,
      remetenteCnpj: data['remetenteCnpj'] ?? '',
      cidadeDestino: data['cidadeDestino'] ?? '',
      situacaoChecklist: data['situacaoChecklist'],
      recomendacaoChecklist: data['recomendacaoChecklist'],
      dataChecklist: data['dataChecklist'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'] ?? 0,
      deleted: data['deleted'] ?? false,
      dirty: false,
    );
  }

  // TO FIRESTORE
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'descricao': descricao,
      'peso': peso,
      'valorNfe': valorNfe,
      'remetenteCnpj': remetenteCnpj,
      'cidadeDestino': cidadeDestino,
      'situacaoChecklist': situacaoChecklist,
      'recomendacaoChecklist': recomendacaoChecklist,
      'dataChecklist': dataChecklist,
      'createdBy': createdBy,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'deleted': deleted,
    };
  }

  // COPY WITH
  ProductModel copyWith({
    int? id,
    String? firestoreId,
    String? nome,
    String? descricao,
    double? peso,
    double? valorNfe,
    String? remetenteCnpj,
    String? cidadeDestino,
    String? situacaoChecklist,
    String? recomendacaoChecklist,
    int? dataChecklist,
    String? createdBy,
    int? updatedAt,
    bool? deleted,
    bool? dirty,
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
      situacaoChecklist: situacaoChecklist ?? this.situacaoChecklist,
      recomendacaoChecklist:
          recomendacaoChecklist ?? this.recomendacaoChecklist,
      dataChecklist: dataChecklist ?? this.dataChecklist,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
    );
  }
}
