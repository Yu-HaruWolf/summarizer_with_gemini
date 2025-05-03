import 'package:flutter/material.dart';

import 'document_detail_page.dart';
import 'gemini_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textInputController = TextEditingController();
  final _inputDocumentController = TextEditingController();

  final _geminiService = GeminiService();

  String _geminiResponse = "Response";

  @override
  initState() {
    super.initState();
  }

  Future<void> inputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('文章を入力'),
          content: TextField(
            controller: _inputDocumentController,
            decoration: InputDecoration(hintText: "ここに入力"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final text = _inputDocumentController.text;
                await _geminiService.sendMessage(text);
                final title = _geminiService.getLatestTitle();
                final keywords = _geminiService.getLatestKeywords();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DocumentDetailPage(
                          title: title,
                          document: text,
                          keywords: keywords,
                        ),
                  ),
                );
                print(_inputDocumentController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getResponse(String text) async {
    await _geminiService.sendMessage(text);
    return _geminiService.getLatestResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          inputDialog(context);
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle),
                              SizedBox(width: 30),
                              Text("新規文章の要約"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(_geminiResponse),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: _textInputController)),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      print(_textInputController.text);
                      String response = await getResponse(
                        _textInputController.text,
                      );
                      setState(() {
                        _geminiResponse = response;
                      });
                    },
                    child: Text("Send"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
