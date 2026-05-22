abstract class Produto {
  final String id;
  final String nome;
  final double preco;
  final String imagemUrl;
  final double avaliacao;
  final int totalReviews;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagemUrl,
    required this.avaliacao,
    required this.totalReviews,
  });
}

// Subclasse 1: Buquês
class Buque extends Produto {
  final String tipoFlor;

  Buque({
    required super.id,
    required super.nome,
    required super.preco,
    required super.imagemUrl,
    required super.avaliacao,
    required super.totalReviews,
    required this.tipoFlor,
  });
}

// Subclasse 2: Pelúcias (Bears)
class Pelucia extends Produto {
  final String tamanho;

  Pelucia({
    required super.id,
    required super.nome,
    required super.preco,
    required super.imagemUrl,
    required super.avaliacao,
    required super.totalReviews,
    required this.tamanho,
  });
}

// Lista simulada para popular a interface antes de integrarmos a API (GET)
final List<Produto> mockProdutos = [
  Buque(
    id: '1',
    nome: 'Purple Passion Bouquet',
    preco: 80.00,
    imagemUrl: 'https://png.pngtree.com/png-clipart/20250119/original/pngtree-valentines-day-red-and-pink-roses-bouquet-png-image_20303425.png',
    avaliacao: 5.0,
    totalReviews: 25,
    tipoFlor: 'Rosas e Lírios',
  ),
  Buque(
    id: '2',
    nome: 'Classic Red Roses',
    preco: 120.00,
    imagemUrl: 'https://png.pngtree.com/png-clipart/20250119/original/pngtree-valentines-day-red-and-pink-roses-bouquet-png-image_20303425.png', // Usando a mesma imagem como placeholder
    avaliacao: 4.8,
    totalReviews: 42,
    tipoFlor: 'Rosas',
  ),
  Pelucia(
    id: '3',
    nome: 'Brown Teddy Bear',
    preco: 65.50,
    imagemUrl: 'https://png.pngtree.com/png-clipart/20250119/original/pngtree-valentines-day-red-and-pink-roses-bouquet-png-image_20303425.png', // Usando a mesma imagem como placeholder
    avaliacao: 4.5,
    totalReviews: 12,
    tamanho: 'Médio',
  ),
];