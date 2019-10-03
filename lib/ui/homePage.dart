
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:nutre_vid/ui/calculadoraIMC.dart';
import 'package:nutre_vid/ui/cadastroPaciente.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   var _scaffoldKey = new GlobalKey<ScaffoldState>();
    int _counter = 0;
    String pesquisa = "";
    SearchBar searchBar;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void onSubmitted(String value) {
    this.pesquisa = value.toLowerCase();  
    setState(() => _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text('Você escreveu $value!'))));
        _incrementCounter();
  }


    @override
  void initState() {
    searchBar = new SearchBar(
        inBar: false,
        hintText: "Pesquisar paciente",
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted);
    super.initState();
  }

    AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text("NutreVid"),
      actions: [
        searchBar.getSearchAction(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: this.searchBar.build(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Encontrado $pesquisa',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> CadastroPacientePage()),
          );
        },

        tooltip: 'Cadastrar',
        child: Icon(Icons.add),
      ),
    );
      
    
  }
}