import 'package:todo_as_issue/lexer/tokens.dart';
import 'package:todo_as_issue/parser/error_reporter.dart';
import 'package:todo_as_issue/parser/todo.dart';

class TokenIterator implements Iterator {
  final List<Token> tokens;
  int cursor = 0;

  TokenIterator(this.tokens);

  @override
  get current => tokens[cursor];

  @override
  bool moveNext() {
    if (hasNext()) {
      cursor++;
      return true;
    } else {
      return false;
    }
  }

  bool hasNext() {
    return cursor < tokens.length;
  }
}

class Parser {
  final List<Token> tokens;
  ErrorReporter errorReporter = ErrorReporter();

  Parser(this.tokens);

  List<Todo> parse() {
    List<Todo> todos = [];
    TokenIterator iterator = TokenIterator(tokens);

    while (iterator.hasNext()) {
      // TODO: try to refactor this while-loop
      if (iterator.current.kind != TokenKind.hashSymbol) {
        errorReporter.reportError(iterator.current);
      }
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.openingParenthesis) {
        errorReporter.reportError(iterator.current);
      }
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.number) {
        errorReporter.reportError(iterator.current);
      }
      int todoId = int.parse(iterator.current.lexeme);
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.closingParenthesis) {
        errorReporter.reportError(iterator.current);
      }
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.openingSquareBracket) {
        errorReporter.reportError(iterator.current);
      }
      iterator.moveNext();

      bool wasPosted = false;
      if (iterator.current.kind == TokenKind.tilde) {
        wasPosted = true;
        iterator.moveNext();
      }

      if (iterator.current.kind != TokenKind.closingSquareBracket) {
        errorReporter.reportError(iterator.current);
      }
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.colon) {
        errorReporter.reportError(iterator.current);
      }
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.issueName) {
        errorReporter.reportError(iterator.current);
      }
      String issueTitle = iterator.current.lexeme;
      iterator.moveNext();

      if (iterator.current.kind != TokenKind.semicolon) {
        errorReporter.reportError(iterator.current);
      }

      if (iterator.hasNext()) iterator.moveNext();

      Todo todo = Todo(id: todoId, wasPosted: wasPosted, title: issueTitle);
      todos.add(todo);
    }
    return todos;
  }
}
