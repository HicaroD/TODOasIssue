import 'dart:convert';
import 'dart:io';
import 'package:todo_as_issue/api/api.dart';
import 'package:todo_as_issue/api/github.dart';
import 'package:todo_as_issue/lexer/lexer.dart';
import 'package:todo_as_issue/lexer/tokens.dart';
import 'package:todo_as_issue/parser/parser.dart';
import 'package:todo_as_issue/parser/todo.dart';
import 'package:todo_as_issue/utils/configuration.dart';
import 'package:todo_as_issue/utils/reader.dart';

class TodoAsIssue {
  late Lexer lexer;
  late Parser parser;
  late API api;
  final Configuration configuration;
  final String todoFile;

  TodoAsIssue({required this.todoFile, required this.configuration});

  void run() async {
    lexer = Lexer(todoFile);
    List<Token> tokens = lexer.tokenize();
    parser = Parser(tokens);
    List<Todo> todos = parser.parse();

    // TODO: implementar interface para fazer usuário decidir entre GitHub ou GitLab
    GitHub github = GitHub.instance;
    API api = API(github);

    api.createIssues(todos, configuration);
  }
}

Future<Map<String, dynamic>> getConfigFile() async {
  String path = 'todo.json';
  File jsonFile = File(path);

  if (!await jsonFile.exists()) {
    print(
        "ERROR: Configuration file 'todo.json' not found on project root folder");
    exit(1);
  }
  Map<String, dynamic> jsonDecoded = jsonDecode(await jsonFile.readAsString());
  return jsonDecoded;
}

Future<String> getTodoFile(String filePath) async {
  File todoFile = File(filePath);
  if (!await todoFile.exists()) {
    print("ERROR: 'todo.txt' not found");
    exit(1);
  }
  String content = await todoFile.readAsString();
  return content;
}

void main(List<String> args) async {
  String todoFile = await Reader.getTodoFile("examples/todo.txt");
  Map<String, dynamic> configAsJson = await Reader.getConfigFile();
  Configuration configuration = Configuration.fromJson(configAsJson);

  TodoAsIssue todoAsIssue =
      TodoAsIssue(todoFile: todoFile, configuration: configuration);
  todoAsIssue.run();
}
