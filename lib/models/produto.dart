// lib/models/produto.dart

// Classe abstrata base — C11: utilizando classes e POO
abstract class Produto {
  final String id;
  final String nome;
  final double preco;
  final String imagemUrl;
  final double avaliacao;
  final int totalReviews;

  const Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagemUrl,
    required this.avaliacao,
    required this.totalReviews,
  });

  // C11: getter abstrato — cada subclasse implementa de forma diferente
  String get categoria;

  // C11: método concreto — serializa os atributos comuns para JSON (usado no POST/PUT da API)
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'preco': preco,
        'imagemUrl': imagemUrl,
        'avaliacao': avaliacao,
        'totalReviews': totalReviews,
        'categoria': categoria, // usado pelo fromJson para saber qual subclasse criar
      };

  // C11: factory constructor — desserializa o JSON da API para o objeto correto
  factory Produto.fromJson(Map<String, dynamic> json) {
    final cat = json['categoria'] ?? '';
    if (cat == 'Pelucia') {
      return Pelucia(
        id: json['id'].toString(),
        nome: json['nome'] ?? '',
        preco: (json['preco'] as num).toDouble(),
        imagemUrl: json['imagemUrl'] ?? '',
        avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 0.0,
        totalReviews: json['totalReviews'] as int? ?? 0,
        tamanho: json['tamanho'] ?? 'Médio',
      );
    }
    // Padrão: Buque
    return Buque(
      id: json['id'].toString(),
      nome: json['nome'] ?? '',
      preco: (json['preco'] as num).toDouble(),
      imagemUrl: json['imagemUrl'] ?? '',
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      tipoFlor: json['tipoFlor'] ?? 'Variado',
    );
  }
}

// C11: Subclasse 1 — Buquês
class Buque extends Produto {
  final String tipoFlor;

  const Buque({
    required super.id,
    required super.nome,
    required super.preco,
    required super.imagemUrl,
    required super.avaliacao,
    required super.totalReviews,
    required this.tipoFlor,
  });

  @override
  String get categoria => 'Buque';

  // C11: override de toJson — adiciona campo específico da subclasse
  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(), // aproveita os campos da superclasse
        'tipoFlor': tipoFlor,
      };
}

// C11: Subclasse 2 — Pelúcias
class Pelucia extends Produto {
  final String tamanho;

  const Pelucia({
    required super.id,
    required super.nome,
    required super.preco,
    required super.imagemUrl,
    required super.avaliacao,
    required super.totalReviews,
    required this.tamanho,
  });

  @override
  String get categoria => 'Pelucia';

  // C11: override de toJson — adiciona campo específico da subclasse
  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'tamanho': tamanho,
      };
}

// Lista mock — usada como fallback se a API estiver indisponível
final List<Produto> mockProdutos = [
  Buque(
    id: '1',
    nome: 'Purple Passion Bouquet',
    preco: 80.00,
    imagemUrl:
        'https://png.pngtree.com/png-clipart/20250119/original/pngtree-valentines-day-red-and-pink-roses-bouquet-png-image_20303425.png',
    avaliacao: 5.0,
    totalReviews: 25,
    tipoFlor: 'Rosas e Lírios',
  ),
  Buque(
    id: '2',
    nome: 'Classic Red Roses',
    preco: 120.00,
    imagemUrl:
        'https://png.pngtree.com/png-clipart/20250119/original/pngtree-valentines-day-red-and-pink-roses-bouquet-png-image_20303425.png',
    avaliacao: 4.8,
    totalReviews: 42,
    tipoFlor: 'Rosas',
  ),
  Pelucia(
    id: '3',
    nome: 'Brown Teddy Bear',
    preco: 65.50,
    imagemUrl:
        'https://png.pngtree.com/png-clipart/20250119/original/pngtree-valentines-day-red-and-pink-roses-bouquet-png-image_20303425.png',
    avaliacao: 4.5,
    totalReviews: 12,
    tamanho: 'Médio',
  ),
];