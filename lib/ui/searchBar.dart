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
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
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
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final listaDeSugestao = query.isEmpty? cidadesRecentes: cidades.where((p) => p.toLowerCase().startsWith(query)).toList();
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      onTap: (){
        Navigator.pop(context);
      },
      leading: Icon(Icons.location_city),
      title: RichText(text: TextSpan(
        text: listaDeSugestao[index].substring(0, query.length),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: listaDeSugestao[index].substring(query.length),
            style: TextStyle(color: Colors.grey)
          )
        ]

      ),
      ),
    ),
    itemCount: listaDeSugestao.length,
    );
  }
}
