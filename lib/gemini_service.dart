import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'gemini_tools.dart';

class GeminiService {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
  late final GenerativeModel model;
  late final ChatSession chatSession;

  final List<String> responseHistory = List<String>.empty(growable: true);

  String title = "";
  String keywords = "";

  GeminiService() {
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      tools: [GeminiTools.tool],
      systemInstruction: Content.text(
        "ユーザーが与えた文章に対して、タイトルを付け、キーワードを抽出し、setTitle関数に渡してください。",
      ),
    );
    chatSession = model.startChat();
  }

  String getLatestResponse() {
    return responseHistory[responseHistory.length - 1];
  }

  String getLatestTitle() {
    return this.title;
  }

  String getLatestKeywords() {
    return this.keywords;
  }

  Future<void> sendMessage(String text) async {
    final GenerateContentResponse response = await chatSession.sendMessage(
      Content.text(text),
    );
    final textResponse = response.text;
    if (textResponse != null) {
      print(textResponse);
      responseHistory.add(textResponse);
    }

    if (response.functionCalls.isNotEmpty) {
      final geminiTools = GeminiTools();
      final functionResultResponse = await chatSession.sendMessage(
        Content.functionResponses([
          for (final functionCall in response.functionCalls)
            FunctionResponse(
              functionCall.name,
              geminiTools.handleFunction(functionCall.name, functionCall.args),
            ),
        ]),
      );
      this.title = geminiTools.getLatestTitle();
      this.keywords = geminiTools.getLatestKeywords();
      final responseText = functionResultResponse.text;
      if (responseText != null) {
        responseHistory.add(responseText);
      }
    }
  }
}
