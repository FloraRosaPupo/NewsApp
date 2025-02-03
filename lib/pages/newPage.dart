import 'package:flutter/material.dart';
import 'package:newa/data/model/newsModel.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key, required this.item});

  final NewsModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(item.source.name),
      ),
      body: Column(children: [
        Image.network(
          item.image,
          height: 200,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                item.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                item.description,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: (){
                  Uri.file('${item.url}');
                },
                child: const Text('Acessar noticia completa'),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
