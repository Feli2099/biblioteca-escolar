class Livro {
  final String titulo;
  final String autor;
  final String isbn;
  final String editora;
  final String? urlCapa;

  Livro({
    required this.titulo,
    required this.autor,
    required this.isbn,
    required this.editora,
    this.urlCapa,
  });

  Map<String,dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'isbn': isbn,
      'editora': editora,
      'urlCapa': urlCapa,
    };
  }

  factory Livro.fromMap(Map<String,dynamic> map) {
    return Livro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      isbn: map['isbn'] ?? '',
      editora: map['editora'] ?? '',
      urlCapa: map['urlCapa'],
    );
  }
}