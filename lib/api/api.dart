import 'dart:io';

import 'package:todo_as_issue/api/opensource_platform.dart';
import 'package:todo_as_issue/core/http_client/http_client_interface.dart';

import '../parser/todo.dart';
import '../utils/configuration.dart';

class API {
  IOpenSourcePlatform _openSourcePlatform;

  API(this._openSourcePlatform);

  set openSourcePlatform(IOpenSourcePlatform openSourcePlatform) {
    _openSourcePlatform = openSourcePlatform;
  }

  void createIssues(List<Todo> todos, Configuration configuration) async {
    int issueCounter = 0;

    for (Todo todo in todos) {
      if (!todo.wasPosted) {
        HttpResponse response =
            await _openSourcePlatform.createIssue(todo, configuration);

        if (response.statusCode != 201) {
          print("Error: Can't create issue");
          print(response.statusCode);
          print(response.body);
          exit(1);
        }
        issueCounter++;
        // This is useful for avoiding problems with GitHub's rate limit policies
        sleep(Duration(seconds: 2));
      }
    }
    if (issueCounter == 0) {
      print("No issues were created");
    } else if (issueCounter == 1) {
      print("🎉 $issueCounter issue was created successfully 🎉");
    } else {
      print("🎉 $issueCounter issues were created successfully 🎉");
    }
  }
}
