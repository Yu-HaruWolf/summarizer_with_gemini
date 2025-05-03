import 'dart:core';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiTools {
  static Tool tool = Tool(
    functionDeclarations: [
      FunctionDeclaration(
        "setTitle",
        "文章のタイトルとキーワードを抽出した値を渡す関数",
        Schema.object(
          properties: {
            'title': Schema.string(description: "文章のタイトル"),
            'keywords': Schema.string(description: "文章のキーワード。カンマ区切りで複数可"),
          },
          requiredProperties: ['title', 'keywords'],
        ),
      ),
    ],
  );

  String title = "";
  String keywords = "";

  Map<String, Object?> handleFunction(
    String functionName,
    Map<String, Object?> arguments,
  ) {
    return switch (functionName) {
      'setTitle' => handleSetTitle(arguments),
      _ => handleUnknownFunction(functionName),
    };
  }

  Map<String, Object?> handleSetTitle(Map<String, Object?> arguments) {
    final title = arguments['title'] as String;
    final keywords = arguments['keywords'] as String;
    print('title: $title');
    print('keywords: $keywords');
    this.title = title;
    this.keywords = keywords;
    final functionResults = {
      'success': true,
      'title': title,
      'keywords': keywords,
    };
    return functionResults;
  }

  String getLatestTitle() {
    return this.title;
  }

  String getLatestKeywords() {
    return this.keywords;
  }

  Map<String, Object?> handleUnknownFunction(String functionName) {
    print('Unsupported function call $functionName');
    return {
      'success': false,
      'reason': 'Unsupported function call $functionName',
    };
  }
}
