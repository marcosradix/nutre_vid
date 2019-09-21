import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nutre_vid/ui/cadastroDieta.dart';
import 'package:nutre_vid/ui/calculadoraIMC.dart';
import 'package:nutre_vid/ui/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutreVid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'NutreVid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final HomePage _home = HomePage();
    final CadastroDietaPage _cadastroDieta = CadastroDietaPage();
    final CalculadoraImcPage _calculadoraImcPage = CalculadoraImcPage();

    Widget _paginaSelecionada(int page) {
      switch (page) {
        case 0:
          return _home;
        case 1:
          return _cadastroDieta;
        case 2:
          return _calculadoraImcPage;
        default:
          return Center(
            child: Text("$page"),
          );
      }
    }

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        animationDuration: Duration(milliseconds: 200),
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.computer, size: 30),
          Icon(Icons.contact_phone, size: 30)
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: Container(
        child: _paginaSelecionada(_page),
      ),
    );
  }
}
