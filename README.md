# :pencil: TODOasIssue

## Summary

1. [Description](#description)
2. [Installation](#installation)
3. [Setting up `TodoAsIssue`](#setting-up-todoasissue)

    3.1. [Required fields for GitHub](#required-fields-for-github)

    3.2. [Required fields for GitLab](#required-fields-for-gitlab)

4. [Usage](#usage)
5. [Project architecture](#project-architecture)
6. [Supported platforms](#supported-platforms)
7. [Design patterns used](#design-patterns-used)
8. [UML diagram](#uml-diagram)
9. [License](#license)

## Description

From a list of TODOs to a list of issues on your GitHub or GitLab repository.

```
[~]: "This is my first TODO";
[]: "This is my second TODO";
```

GitHub and Gitlab projects can have issues created by developers / users to report errors, bugs and etcetera. The idea of building `TODOasIssue` is to automate the creation of issues locally by writing everything that you need in a simple text file and publishing it to your GitHub / GitLab project without even opening your browser to do that.

## Installation
First of all, you need to have Dart installed on your computer. See [Dart documentation](https://dart.dev/get-dart). After that, run the following command:

```bash
dart pub global activate todo_as_issue
```

Now you have `TodoAsIssue` installed.

## Setting up `TodoAsIssue`

On your project root folder, create a file called `todo.json` and paste the content below:

```json
{
    "owner": "YOUR_GITHUB_USERNAME",
    "repo_name_github": "YOUR_GITHUB_REPOSITORY_NAME",
    "repo_id_gitlab": "YOUR_GITLAB_PROJECT_ID",
    "platform": "YOUR_OPEN_SOURCE_PLATFORM",
    "github_token": "YOUR_PRIVATE_TOKEN_FROM_GITHUB",
    "gitlab_token": "YOUR_PRIVATE_TOKEN_FROM_GITLAB"
}
```

In `platform` field, you can use `github` or `gitlab`.

After that, you can create a file called `todo.txt` in the project root folder to insert all your TODOs. For more informations and examples about how to create a TODO file, go [here](./examples/).

### Required fields for GitHub

- `owner`: Your username
- `repo_name_github`: Your repository
- `platform`: It should be set to `github`
- `github_token`: Your private access token. See [GitHub Docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

Leave the remaining ones empty (empty string).

### Required fields for GitHub

- `repo_id_gitlab`: Your repository id
- `platform`: It should be set to `gitlab`
- `gitlab_token`: Your private access token. See [GitLab Docs](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)

Leave the remaining ones empty (empty string).

**WARNING**: Insert this file `todo.json` on your `.gitignore` in order to keep your informations safe, especially your private token.

## Usage

After setting up `TodoAsIssue`, go to your project's root directory and run the following command:

```
todo_as_issue
```

That command will look for `todo.json` and `todo.txt` on project's root directory.

## Project architecture
-  [`lib/api`](./lib/api/): Code that is related to the API's communication.
   - [`lib/api/api.dart`](./lib/api/api.dart): Class for calling method to create issues
   - [`lib/api/github.dart`](./lib/api/github.dart): Class for implementing the communication with GitHub's API to create an issue.
   - [`lib/api/gitlab.dart`](./lib/api/gitlab.dart): Class for implementing the communication with GitLab's API to create an issue.
   - [`lib/api/opensource_platform.dart`](./lib/api/opensource_platform.dart): Interface for any open source platform that I may want to create in the future.
-  [`lib/core`](./lib/core/): Code that is common across all the source code.
   - [`lib/core/http_client`](./lib/core/http_client/): Implementation of an HTTP client
     - [`lib/core/http_client/http_client_interface.dart`](./lib/core/http_client/http_client_interface.dart): Interface for any HTTP client that I may want to create in the future. This is useful because my code will not be dependent
     - [`lib/core/http_client/http_client.dart`](./lib/core/http_client/http_client.dart): Implementation of an HTTP Client using [`http`](https://pub.dev/packages/http) package.
-  [`lib/lexer`](./lib/lexer/): Tool for converting a text file into a list of tokens
   -  [`lib/lexer/lexer.dart`](./lib/lexer/lexer.dart): Implementation of lexer (tokenizer)
   -  [`lib/lexer/position.dart`](./lib/lexer/position.dart): Class for managing cursor and line positions
   -  [`lib/lexer/tokens.dart`](./lib/lexer/tokens.dart): Class for representing a token and an enum to represent a token kind.
-  [`lib/parser`](./lib/parser/): Tool for converting a list of tokens into a list of TODOs
   - [`lib/parser/error_reporter.dart`](./lib/parser/error_reporter.dart): Class for simply reporting a parsing error (every time a todo file is not formatted, this class should throw an error and close the program).
   - [`lib/parser/parser.dart`](./lib/parser/parser.dart): Class for converting a list of tokens (generated by the lexer) into a list of TODOs
   - [`lib/parser/todo.dart`](./lib/parser/todo.dart): Class for representing a TODO object.
-  [`lib/utils`](./lib/utils/): Utility code
   -  [`lib/utils/configuration.dart`](./lib/utils/configuration.dart): Data class for representing `todo.json`.
   -  [`lib/utils/endpoints.dart`](./lib/utils/endpoints.dart): Important endpoints
   -  [`lib/utils/reader.dart`](./lib/utils/reader.dart): Helper class for reading importants files (`todo.json` and `todo.txt`)
-  [`test`](./test/): Folder for storing all tests
   - [`test/lexer_test.dart`](./test/lexer_test.dart): Unit test for lexer
   - [`test/parser_test.dart`](./test/parser_test.dart): Unit test for parser

## Supported platforms

- Linux: Working properly on Manjaro Arch Linux.
- Windows: It might work, but it was not tested.
- macOS: It might work, but it was not tested.

## UML Diagram
My UML diagram is very big, therefore I'll just link to the file instead of trying to put it here. Check it [here](diagram.puml).

## Design patterns used

- [Iterator](https://refactoring.guru/design-patterns/iterator)

    Iterator pattern was used on the parser implementation. I used it for iterating over a list of tokens. Additionally, even though Dart provides a built-in iterator for `List`, Dart doesn't offer me a method called `hasNext()` to check if there is a next element to iterate, that's why I implemented this pattern, just for building this method by myself. You can check it out [here](https://github.com/HicaroD/TodoAsIssue/blob/master/lib/parser/parser.dart).

- [Singleton](https://refactoring.guru/design-patterns/singleton)

    Singleton pattern was used on the implementation of open source platforms, such as GitHub and GitLab. I decided to use it because I didn't want to have more than one instance of each platform on my program, it should be unique, makes no sense to have more than one of these. You can check it out [here](https://github.com/HicaroD/TodoAsIssue/blob/master/lib/api/github.dart) and [here](https://github.com/HicaroD/TodoAsIssue/blob/master/lib/api/gitlab.dart).

- [Strategy](https://refactoring.guru/design-patterns/strategy)
 
    Strategy pattern was used on the implementation of open source platforms as well. I decided to do this because we can have more than one kind of open source platforms, such as GitHub and GitLab. Therefore we can change the "strategy" to another open source platform. You can check it out [here](https://github.com/HicaroD/TodoAsIssue/tree/feature/api_communication/lib/api).

- [Facade](https://refactoring.guru/design-patterns/facade)

    Facade pattern was used on the implementation of `TodoAsIssue` class. This class is used for calling all the important methods, just acting like an front-facing interface masking more complex underlying code. It happens because `TodoAsIssue` doesn't know anything about the inner implementations of lexer and parser, for example, that's why it is called "Facade". You can check it out [here](https://github.com/HicaroD/TodoAsIssue/blob/master/bin/todo_as_issue.dart).

## Possible bugs and how to avoid it

1. The program can crash if it has a new line at the end of `todo.txt`. Make sure you don't have a new line at the end.

2. The program can crash if it has extra whitespaces at the end of each TODO in `todo.txt`. Make you sure you don't have these extra whitespaces. 

**I'm working to solve these issues.**

## License
This project is licensed under the MIT license. See [LICENSE](LICENSE).
