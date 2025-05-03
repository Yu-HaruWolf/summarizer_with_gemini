import 'package:flutter/material.dart';

class DocumentDetailPage extends StatelessWidget {
  const DocumentDetailPage({
    Key? key,
    required this.title,
    required this.document,
    required this.keywords,
  }) : super(key: key);

  final String title;
  final String document;
  final String keywords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("タイトル", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(initialValue: title),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("キーワード", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(initialValue: keywords),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("内容", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          Padding(padding: const EdgeInsets.all(8.0), child: Text(document)),
        ],
      ),
    );
  }
}
