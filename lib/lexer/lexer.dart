import 'tokens.dart';

class Lexer {
  final String fileContent;
  int cursor = 0;
  bool isEndOfFile = false;
  late String current_character;

  Lexer(this.fileContent);

  void advance_cursor() {
    if (cursor < fileContent.length - 1) {
      current_character = fileContent[cursor];
      cursor++;
    } else {
      isEndOfFile = true;
    }
  }

  List<Token> tokenize() {
    List<Token> tokens = [];
    while (!isEndOfFile) {
      advance_cursor();
      print(current_character);
    }
    return tokens;
  }
}
