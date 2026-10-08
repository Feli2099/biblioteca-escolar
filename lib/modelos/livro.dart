class Livro {
  final String titulo;
  final String autor;
  final String isbn;
  final String editora;
  final String? urlCapa;
  final String? capaBase64;
  final int quantidadeTotal;

  Livro({
    required this.titulo,
    required this.autor,
    required this.isbn,
    required this.editora,
    this.urlCapa,
    this.capaBase64,
    this.quantidadeTotal =1,
  });

  Map<String,dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'isbn': isbn,
      'editora': editora,
      'urlCapa': urlCapa,
      'capaBase64': capaBase64,
      'quantidadeTotal': quantidadeTotal,
    };
  }

  factory Livro.fromMap(Map<String,dynamic> map) {
    return Livro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      isbn: map['isbn'] ?? '',
      editora: map['editora'] ?? '',
      urlCapa: map['urlCapa'],
      capaBase64: map['capaBase64'] as String?,
      quantidadeTotal: (map['quantidadeTotal'] as num?)?.toInt() ?? 1,
    );
  }
}