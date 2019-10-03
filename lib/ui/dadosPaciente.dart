import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';

class DadosPacienteHome extends StatefulWidget {
  @override
  _DadosPacienteHomeState createState() => _DadosPacienteHomeState();
}

class _DadosPacienteHomeState extends State<DadosPacienteHome> {
  TextEditingController nomeController = TextEditingController();
  final dateFormat = DateFormat("dd/MM/yyyy");
  DateTime date;

  FocusNode myFocusNode = new FocusNode();

  //chave global para validar campos
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                    decoration: InputDecoration(labelText: "Nome",labelStyle: TextStyle(color: Colors.blue)),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                    controller: nomeController,
                    validator: (value) {
                      if (value.isEmpty) {return "Insira o nome";}
                    },
                  ),

                  DateTimePickerFormField(
                    focusNode: myFocusNode,
                    keyboardType: TextInputType.number,
                    inputType: InputType.date,
                    format: dateFormat,
                    editable: true,
                    decoration: InputDecoration(labelText: "Data",labelStyle: TextStyle(color: Colors.blue)),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                    autofocus: false,
                    onChanged: (dt) {
                      setState(() => date = dt);
                    //  print('Selected date: $date');
                    },
                    validator: (val) {
                    if (val == null) {
                      return 'Insira uma data';
                    }
                  }
                  ),

                  Divider(
                    color: Colors.blue,
                    thickness: 2,
                    height: 15,

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
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
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
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Dados processados com sucesso!', textAlign: TextAlign.center,),
                                            backgroundColor: Colors.blue,
                                          ));
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
                  )
                ],
              ),
            )));
  }
}
