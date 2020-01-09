 import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nutre_vid/helpers/paciente_helper.dart';

class PacienteSearchBar extends SearchDelegate<String> {
final pacientesAll =
[
"Fortaleza",
"Caucaia",
"São Paulo",
"Rio de Janeiro",
];

final pacientesRecentes = ["Fortaleza", "São Paulo",];

  @override
  List<Widget> buildActions(BuildContext context) {
    print("buildActions");
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          print("clear");
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    print("buildLeading");
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        print("close");
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print("buildResults");
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: Colors.red,
        shape: StadiumBorder(),
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("buildSuggestions");
    print("query:$query");
    final listaDeSugestao = query.isEmpty ? pacientesRecentes : pacientesAll.where((p) => p.toLowerCase().startsWith(query)).toList();
    return ListView.builder(itemBuilder: (context, index) => ListTile(
      onTap:(){
        showResults(context);
      },
      leading: Icon(MdiIcons.accountSearch, color: Colors.blueAccent, size: 30,),
      title:
      //Text(listaDeSugestao[index],style: TextStyle(color: Colors.blueAccent),),
      RichText(
        text: TextSpan(
            text: listaDeSugestao[index].substring(0, query.length),
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: listaDeSugestao[index].substring(query.length),
                  style: TextStyle(color: Colors.blueAccent)
              )
            ]
        ),
      ),
    ),
    itemCount: listaDeSugestao.length,
    );
  }
}
