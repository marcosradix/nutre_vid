
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:nutre_vid/helpers/paciente_helper.dart';
import 'package:nutre_vid/ui/cadastroPaciente.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nutre_vid/ui/pacienteSearchBar.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final SlidableController slidableController = SlidableController();
  PacienteHelper helper = PacienteHelper();
  List<Paciente> pacientes = List();

   var _scaffoldKey = new GlobalKey<ScaffoldState>();
    int _counter = 0;
    SearchBar searchBar;


  void onChanged(String value) {
    setState(() {
      _getAllPacientesByName(value);
    });
  }

  void onClosed() {
    setState(() {
      Navigator.pop(context);
      _getAllPacientes();
    });
  }

  @override
  void initState() {
      _getAllPacientes();

      searchBar = new SearchBar(
        inBar: false,
        hintText: "Pesquisar paciente",
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: onChanged,
        showClearButton: true,
        colorBackButton: true,
        onClosed: onClosed,
      );
      super.initState();
  }

    AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text("NutreVid"),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: this.searchBar.build(context),
      body:

      RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
              itemCount: pacientes.length,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index){
                return _pacienteCard(context, index);
              })
      ),


//      Center(
//        child:ListView.builder(
//            itemCount: pacientes.length,
//            padding: EdgeInsets.all(10.0),
//            itemBuilder: (context, index){
//              return _pacienteCard(context, index);
//            })
//   ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Cadastrar',
        child: Icon(Icons.add),
        onPressed: (){
          _showPacientePage();
        },
      ),
    );
  }

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _getAllPacientes();
    });
  }

   void _showPacientePage({Paciente paciente}) async{
     final recPaciente = await Navigator.push(context,//nome parametro    parametro
         MaterialPageRoute(builder: (context) => CadastroPacientePage(paciente: paciente))
     );
     if(recPaciente != null){
       if(paciente != null){
         print("updating");
         await helper.updatePaciente(recPaciente);
       }else{
         print("saving");
         await helper.savePaciente(recPaciente);
       }
       _getAllPacientes();
     }
   }

  void _getAllPacientes() {
    helper.getAllPaciente().then((list) {
      setState(() {
        pacientes = list;
      });
    });
  }

  void _getAllPacientesByName(String name) {
    helper.getPacientesByName(name).then((list) {
      setState(() {
        pacientes = list;
      });
    });
  }


  Widget _pacienteCard(BuildContext context, int index){
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      controller: slidableController,

      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.lightBlueAccent,
          icon: Icons.more_horiz,
          onTap: (){_showPacientePage(paciente: pacientes[index]);},
        ),
        IconSlideAction(
          closeOnTap: false,
          caption: 'Deletar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _exibiDialogDelete(context, pacientes[index]);
          },
        ),
      ],


      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: pacientes[index].foto != null ?
                        FileImage(File(pacientes[index].foto)) :
                        AssetImage("images/person_blue.png")
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Nome: ",style: TextStyle(fontSize: 18,color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                        Text(pacientes[index].nome ?? "", style: TextStyle(fontSize: 15,color: Colors.blue, fontWeight: FontWeight.bold),),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Text("Data Nanscimento: ",style: TextStyle(fontSize: 17,color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                        Text(pacientes[index].dataNascimento ?? "", style: TextStyle(fontSize: 15,color: Colors.blue, fontWeight: FontWeight.bold),),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Text("Idade: ",style: TextStyle(fontSize: 18,color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                        Text(pacientes[index].idade ?? "", style: TextStyle(fontSize: 15,color: Colors.blue, fontWeight: FontWeight.bold),),
                      ],
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  _exibiDialogDelete(context, Paciente paciente){
    print("excluindo paciente $paciente");
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Deletar Paciente"),
            content: Text("Deseja realmente deletar esse paciente?"),
            actions: <Widget>[
              FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){Navigator.pop(context);}),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                 helper.deletePaciente(paciente.id).then((int){
                   Navigator.pop(context);
                   _getAllPacientes();
                 });
                },
              )
            ],
          );
        }
    );
  }
}