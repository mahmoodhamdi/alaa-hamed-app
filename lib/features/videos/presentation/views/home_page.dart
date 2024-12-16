import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فيديوهات م. علاء حامد'),
      ),
      body: ListView.builder(
        itemCount: 10, // مؤقتًا نعرض 10 عناصر
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.video_library,
                color: Theme.of(context).primaryColor),
            title: Text('عنوان الفيديو $index'),
            subtitle: Text('وصف الفيديو $index'),
            onTap: () {
              // تنفيذ عند الضغط على الفيديو
            },
          );
        },
      ),
    );
  }
}
