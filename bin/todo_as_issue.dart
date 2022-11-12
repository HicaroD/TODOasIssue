import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:todo_as_issue/api/api.dart';
import 'package:todo_as_issue/api/github.dart';
import 'package:todo_as_issue/api/gitlab.dart';
import 'package:todo_as_issue/api/opensource_platform.dart';
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
  final OpenSourcePlatform openSourcePlatform;

  TodoAsIssue(
      {required this.todoFile,
      required this.configuration,
      required this.openSourcePlatform});

  void run() async {
    lexer = Lexer(todoFile);
    List<Token> tokens = lexer.tokenize();
    parser = Parser(tokens);
    List<Todo> todos = parser.parse();

    API api = API(openSourcePlatform);

    api.createIssues(todos, configuration);
  }
}

OpenSourcePlatform getPlatformFromCommandLine(List<String> args) {
  ArgParser parser = ArgParser();
  parser.addOption("platform", abbr: "p", defaultsTo: "github");
  ArgResults results = parser.parse(args);

  OpenSourcePlatform openSourcePlatform = GitHub();

  if (results["platform"] == "Gitlab") {
    openSourcePlatform = GitLab();
  }

  return openSourcePlatform;
}

void main(List<String> args) async {
  String todoFile = await Reader.getTodoFile("examples/todo.txt");
  Map<String, dynamic> configAsJson = await Reader.getConfigFile();
  Configuration configuration = Configuration.fromJson(configAsJson);
  OpenSourcePlatform openSourcePlatform = getPlatformFromCommandLine(args);

  TodoAsIssue todoAsIssue = TodoAsIssue(
      todoFile: todoFile,
      configuration: configuration,
      openSourcePlatform: openSourcePlatform);
  todoAsIssue.run();
}
