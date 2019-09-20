import 'package:flutter/material.dart';

class SearchBar extends SearchDelegate<String> {
final cidades =  [
"Fortaleza",
"Caucaia"
];

final cidadesRecentes = ["Fortaleza"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final listaDeSugestao = query.isEmpty? cidadesRecentes: cidades;
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      leading: Icon(Icons.location_city),
      title: Text(listaDeSugestao[index]),
    ),
    itemCount: listaDeSugestao.length,
    );
  }
}
