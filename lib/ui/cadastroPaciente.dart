import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nutre_vid/ui/calculadoraIMC.dart';
import 'package:nutre_vid/ui/dadosPaciente.dart';

class CadastroPacientePage extends StatefulWidget {
  CadastroPacientePage();

  @override
  _CadastroPacientePageState createState() => _CadastroPacientePageState();
}

class _CadastroPacientePageState extends State<CadastroPacientePage> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final DadosPacienteHome _dadosPaciente = DadosPacienteHome();
    final CalculadoraImcPage _calculadoraImcPage = CalculadoraImcPage();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Cadastro de Paciente'),
          bottom: TabBar(
            tabs: [
              Tab(text: "DADOS PACIENTE",),
              Tab(text: "DIETA"),
            ],
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 10),
              icon: Icon(MdiIcons.clipboardTextOutline, size: 40,color: Colors.white),
              onPressed: (){},
            )]),
        body: Center(
          child: TabBarView(
            children: [
              _dadosPaciente,
              _calculadoraImcPage
            ],
          ),
        ),
      ),
    );




  }
}
