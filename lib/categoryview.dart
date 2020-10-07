import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SpellingWizard/challenge.dart';
import 'package:SpellingWizard/word.dart';
import 'package:tuple/tuple.dart';

class CategoryView extends StatelessWidget {
  final String title;
  final int itemCount;
  final Color color;
  CategoryView({this.title, this.itemCount, this.color});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
        backgroundColor: this.color,
      ),
      body: _categListView(context),
    );
  }

  ListView _categListView(BuildContext context) {
    List<Word> wordList = [];
    loadAsset(int index) async {
      final myData = await rootBundle.loadString(
          "assets/categories/${this.title}_words/challenge$index.csv");
      List<List<dynamic>> data = CsvToListConverter().convert(myData);
      wordList = convertListToWords(data);
    }

    return ListView.builder(
      itemCount: this.itemCount,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('Challenge number $index'),
            subtitle: Text('Put Small Description Here'),
            leading: starsIcons(),
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {
              Tuple2 audioPrefix = Tuple2<String, int>(
                  'assets/categories/${this.title}_words/challenges_audio/',
                  index);
              await loadAsset(index);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChallengePage(wordList, this.color, audioPrefix)));
            },
          ),
        );
      },
    );
  }
}

Container starsIcons() {
  return Container(
    width: 70,
    child: Row(
      children: <Icon>[
        Icon(
          Icons.star,
          size: 20,
        ),
        Icon(
          Icons.star,
          size: 25,
        ),
        Icon(
          Icons.star,
          size: 20,
        )
      ],
    ),
  );
}
