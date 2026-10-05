# Biblioteca Escolar

Aplicativo desenvolvido em Flutter para auxiliar no gerenciamento de uma biblioteca escolar, permitindo o cadastro de livros e alunos, além do controle de empréstimos e devoluções.

## Objetivo

O projeto tem como objetivo facilitar a organização da biblioteca escolar, centralizando informações sobre livros, alunos e empréstimos em uma aplicação simples e de fácil utilização.

## Funcionalidades

### Livros

- Cadastro manual de livros
- Listagem de livros cadastrados
- Edição de livros
- Exclusão de livros
- Validação de ISBN-10 e ISBN-13
- Prevenção de ISBN duplicado
- Leitura de código de barras/ISBN utilizando a câmera
- Busca automática de informações do livro pelo ISBN
- Consulta à Google Books API
- Consulta complementar à Open Library
- Preenchimento automático de:
    - título
    - autor
    - editora
    - capa
- Exibição da capa dos livros

### Alunos

- Cadastro de alunos
- Listagem de alunos
- Edição de alunos
- Exclusão de alunos
- Armazenamento de nome completo e turma

### Empréstimos

- Registro de empréstimos
- Seleção do aluno
- Seleção do livro
- Definição da data prevista de devolução
- Bloqueio de novo empréstimo para livros que já possuem um empréstimo ativo

### Em desenvolvimento

- Listagem de empréstimos
- Registro de devolução
- Melhorias na interface
- Preparação para uso em ambiente escolar

## Persistência de dados

Os dados são armazenados utilizando o Firebase Cloud Firestore.

Atualmente são utilizadas as seguintes coleções:

- `livros`
- `alunos`
- `emprestimos`

## Tecnologias utilizadas

- Flutter
- Dart
- Firebase
- Cloud Firestore
- Google Books API
- Open Library API
- `mobile_scanner`
- `http`

## Plataformas

O desenvolvimento atualmente é voltado para:

- Android
- Web, utilizado principalmente durante o desenvolvimento e testes

## Google Books API

A chave da Google Books API não é armazenada diretamente no código.

Para executar o projeto informando a chave:

```bash
flutter run -d chrome --dart-define=GOOGLE_BOOKS_API_KEY=SUA_CHAVE