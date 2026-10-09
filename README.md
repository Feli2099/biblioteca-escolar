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
- Seleção manual de capa pela galeria
- Alteração e remoção da capa manual
- Controle da quantidade de cópias de cada livro
- Exibição da quantidade de cópias disponíveis
- Proteção contra exclusão de livros com empréstimos ativos

### Alunos

- Cadastro de alunos
- Listagem de alunos
- Edição de alunos
- Exclusão de alunos
- Armazenamento de nome completo e turma
- Proteção contra exclusão de alunos com empréstimos ativos

### Empréstimos

- Registro de empréstimos
- Seleção do aluno
- Seleção do livro
- Definição da data prevista de devolução
- Controle de disponibilidade das cópias
- Listagem de empréstimos
- Identificação de empréstimos ativos e devolvidos
- Registro da devolução
- Armazenamento da data real de devolução
- Liberação da cópia após a devolução
- Possibilidade de realizar um novo empréstimo do mesmo livro após sua devolução

### Autenticação

- Login utilizando Firebase Authentication
- Acesso ao sistema apenas para usuários autenticados e autorizados
- Controle de usuários autorizados por meio do Firestore

## Persistência de dados

Os dados são armazenados utilizando o Firebase Cloud Firestore.

Atualmente são utilizadas as seguintes coleções:

- `livros`
- `alunos`
- `emprestimos`
- `usuarios_autorizados`

## Tecnologias utilizadas

- Flutter
- Dart
- Firebase Authentication
- Firebase Cloud Firestore
- Google Books API
- Open Library API
- `mobile_scanner`
- `image_picker`
- `http`

## Plataformas

O projeto é voltado principalmente para:

- Android
- Web, utilizado principalmente durante o desenvolvimento e execução dos testes de integração

## Google Books API

A chave da Google Books API não é armazenada diretamente no código-fonte.

Para executar o projeto informando a chave:

```bash
flutter run -d chrome --dart-define=GOOGLE_BOOKS_API_KEY=SUA_CHAVE
```

Para executar em um dispositivo Android:

```bash
flutter run -d DEVICE --dart-define=GOOGLE_BOOKS_API_KEY=SUA_CHAVE
```

Para gerar o APK de produção:

```bash
flutter build apk --release --dart-define=GOOGLE_BOOKS_API_KEY=SUA_CHAVE
```

## Firebase

O projeto utiliza:

- Firebase Authentication para autenticação dos usuários
- Cloud Firestore para persistência dos dados

Para utilizar o projeto com outro ambiente Firebase, é necessário configurar o Firebase para as plataformas desejadas e gerar as configurações correspondentes utilizando o FlutterFire CLI.

## Testes

O projeto possui testes unitários, testes de widgets e testes de integração.

Para executar os testes automatizados:

```bash
flutter test
```

Para realizar a análise estática do projeto:

```bash
flutter analyze
```

Os testes de integração utilizam o Firebase Emulator Suite para evitar alterações nos dados reais durante os testes.

Entre os fluxos testados estão:

- autenticação
- fluxo principal de cadastro e empréstimo
- controle de múltiplas cópias

## Versão

Versão atual:

```text
1.0.0
```

## Status

Versão 1.0 concluída e preparada para utilização em ambiente escolar.