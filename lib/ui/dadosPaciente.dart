import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nutre_vid/helpers/paciente_helper.dart';
import 'package:nutre_vid/ui/util/mascaraData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';


class DadosPacientePage extends StatefulWidget {
  final Paciente paciente;
  //o parametro entre chaves se torna opcional
  DadosPacientePage({this.paciente});

  @override
  _DadosPacientePageState createState() => _DadosPacientePageState();
}


class _DadosPacientePageState extends State<DadosPacientePage> {
  PacienteHelper helper = PacienteHelper();

  //controllers
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _dataController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();

  //variaveis
  final dateFormat = DateFormat("dd/MM/yyyy");
  static final MascaraData _mascaraDataNascimento = new MascaraData();
  double age = 0.0;
  int _selectedYear;
  int _selectedMounth;
  int _selectedDay;
  DateTime now = new DateTime.now().toLocal();
  String dropDownSexo = 'Masculino';
  String dropDownRaca = 'Branco';

  Paciente _editPaciente;
  bool _userEdited = false;

  //chave global para validar campos
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.paciente == null){
      print("paciente nulo");
      _editPaciente = Paciente();
    }else{
      print("paciente nao nulo");
      helper.getPaciente(widget.paciente.id).then((paciente){
        _editPaciente = paciente;
        _nomeController.text = _editPaciente.nome;
        _dataController.text = _editPaciente.dataNascimento;
        _idadeController.text = _editPaciente.idade.toString();
        dropDownSexo = _editPaciente.sexo;
        dropDownRaca = _editPaciente.raca;
       // _editPaciente.foto != null ? FileImage(File(_editPaciente.foto)) : AssetImage("images/person_blue.png");
        setState(() {
          _editPaciente;
        });
      });
    }
  }


  void calculateAge() {
    setState(() {
      if(_selectedMounth < now.month){
        _idadeController.text = ((now.year - _selectedYear) - 1).toString();
      }else if(_selectedMounth == now.month){
        if(_selectedDay < now.day){
          _idadeController.text = ((now.year - _selectedYear) - 1).toString();
        }else{
          _idadeController.text = (now.year - _selectedYear).toString();
        }
      }else{
        _idadeController.text = ((now.year - _selectedYear) - 1).toString();
      }
      _editPaciente.idade = _idadeController.text;
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Nome",
                          prefixIcon: Icon(Icons.account_circle),
                          labelStyle: TextStyle(color: Colors.blue)),
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                      controller: _nomeController,
                      validator: (value) {
                        if (value.isEmpty) {return "Insira o nome";}
                      },
                      onChanged: (text){
                        _userEdited = true;
                        setState(() {
                          _editPaciente.nome = text;
                        });
                      },
                    ),

                    Row(children: [
                      Flexible(
                        flex: 2,
                        child:

                        TextFormField(
                            maxLength: 10,
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                            validator: _validacaoData,
                            controller: _dataController,
                            decoration:  InputDecoration(
                              labelText: 'Data Nascimento',labelStyle: TextStyle(color: Colors.blue),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: (){
                              //oculta teclado
                              FocusScope.of(context).requestFocus(new FocusNode());
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1900, 1, 1),
                                  maxTime: DateTime.now(),
                                  onConfirm: (date) {
                                    _dataController.text = dateFormat.format(date);
                                    _editPaciente.dataNascimento = dateFormat.format(date);
                                    _selectedYear = date.year;
                                    _selectedMounth = date.month;
                                    _selectedDay = date.day;
                                    _userEdited = true;
                                    calculateAge();
                                  },
                                  currentTime: _selectedYear != null ? DateTime(_selectedYear,_selectedMounth,_selectedDay) :
                                  DateTime.now().toLocal());
                            },
                            inputFormatters:  [WhitelistingTextInputFormatter.digitsOnly, _mascaraDataNascimento]
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child:
                        TextFormField(
                            maxLength: 2,
                            controller: _idadeController,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                           // enabled: false,
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                            decoration:  InputDecoration(
                              labelText: 'Idade',
                              prefixIcon: Icon(Icons.cake),
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                            inputFormatters:  [
                              WhitelistingTextInputFormatter.digitsOnly,
                              _mascaraDataNascimento,
                            ]
                        ),
                      )
                    ]),

                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2 ,
                          child: Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 2),
                                  child: Icon(MdiIcons.genderMaleFemale,color: Colors.black54, size: 30,),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5),
                                  child:  Text(
                                    "Sexo", style: TextStyle(
                                      color: Colors.blue, fontSize: 15),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5),
                                  child:  DropdownButton<String>(
                                    value: dropDownSexo,
                                    iconDisabledColor: Colors.blue,
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.blue, fontSize: 13),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropDownSexo = newValue;
                                        _userEdited = true;
                                      });
                                    },
                                    items: <String>['Masculino', 'Feminino', 'Outro', ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(left: 7),
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 2),
                                  child:  Icon(MdiIcons.motherNurse, color: Colors.black54, size: 30,),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5),
                                    child:  Text(
                                      "Raça",style: TextStyle(color: Colors.blue, fontSize: 15),
                                    ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5),
                                  child:  DropdownButton<String>(
                                    value: dropDownRaca,
                                    iconDisabledColor: Colors.blue,
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.blue, fontSize: 13),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropDownRaca = newValue;
                                        _userEdited = true;
                                      });
                                    },
                                    items: <String>['Branco', 'Negro', 'Outro', ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                       Divider(
                         height: 50,
                         color: Colors.blue,
                         thickness: 1.5,
                       ),

                         Column(
                           children: <Widget>[
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 Icon(MdiIcons.camera, color: Colors.black54, size: 30,),
                                 Text('Foto',style: TextStyle(fontSize: 20, color: Colors.blue)),
                               ],
                             ),
                             Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: GestureDetector(
                                     child: Container(
                                       width: 200,
                                       height: 200,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.rectangle,
                                         image: DecorationImage(
                                               image: _editPaciente?.foto != null ?
                                               FileImage(File(_editPaciente.foto)) :
                                               AssetImage("images/person_blue.png")
                                           ),
                                         border: Border.all(color: Colors.blue,width: 2),
                                       ),
                                     ),
                                     onTap: (){
                                       ImagePicker.pickImage(source: ImageSource.camera).then((file){
                                         if(file == null){
                                           return;
                                         }else{
                                           setState(() {
                                             _userEdited = true;
                                             _editPaciente.foto = file.path;
                                           });
                                         }
                                       });
                                     },
                                   ),
                                 ),

                           ],
                       ),


                      Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                      child: RaisedButton(
                                        onPressed: () {
                                          if (_userEdited) {
                                            _exibiDialogAlteracao(context);
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text("Cancelar",style: TextStyle(color: Colors.white, fontSize: 20)),
                                        color: Colors.blue,
                                      ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child:
                                    RaisedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _editPaciente.raca = dropDownRaca;
                                          _editPaciente.sexo = dropDownSexo;
                                          Navigator.pop(context, _editPaciente);
                                        }
                                      },
                                      child: Text(
                                        "Salvar",
                                        style:
                                        TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                  ],
                ),
              ))),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      _exibiDialogAlteracao(context);
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  _exibiDialogAlteracao(context){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){Navigator.pop(context);}),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
      );
  }
}

String _validacaoData(String value) {
  if (value.isEmpty) {
    return 'Formato DD/MM/YYYY';
  }
  if (value.length != 10) {
    return 'Formato DD/MM/YYYY';
  }
  if (!value.startsWith('0') && !value.startsWith('1') &&
      !value.startsWith('2')) {
    if (value.startsWith('3') &&
        (value.substring(1, 2) == '0' || value.substring(1, 2) == '1')) {
      return null;
    }
    return 'Dia inválido!';
  }
  if (value.substring(3, 4) != '0' && value.substring(3, 4) != '1') {
    return 'Mês inválido!';
  }
  if (value.substring(6, 7) != '1' && value.substring(6, 7) != '2') {
    return 'Ano inválido!';
  }
  return null;
}
