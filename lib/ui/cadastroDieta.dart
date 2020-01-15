
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CadastroDietaPage extends StatefulWidget {
  @override
  _CadastroDietaState createState() => _CadastroDietaState();
}

class _CadastroDietaState extends State<CadastroDietaPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _dropDownSexo = 'Masculino';
  String _dropDownRaca = 'Branco';
  String _dropDownKcal = '  ';
  String _dropDownDieta = 'Harris';
  String _title = 'Calculo de Dieta';
  var peso = TextEditingController();

  final String _TIPO_DIETA1 = "Harris";
  final String _TIPO_DIETA2 = "Bolso";

  bool _dietaEditada = false;
  String _tipoDietaSelecionada = null;

  String _validationMessage(String text) {
    return Text(text,style: TextStyle(fontSize: 35.0, color: Colors.blue)).data;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

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
                              value: _dropDownSexo,
                              iconDisabledColor: Colors.blue,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.blue, fontSize: 13),
                              onChanged: (String newValue) {
                                setState(() {
                                  _dropDownSexo = newValue;
                                  _dietaEditada = true;
                                });
                              },
                              items: <String>['Masculino', 'Feminino' ].map<DropdownMenuItem<String>>((String value) {
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
                              value: _dropDownRaca,
                              iconDisabledColor: Colors.blue,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.blue, fontSize: 13),
                              onChanged: (String newValue) {
                                setState(() {
                                  _dropDownRaca = newValue;
                                  _dietaEditada = true;
                                });
                              },
                              items: <String>['Branco', 'Negro' ].map<DropdownMenuItem<String>>((String value) {
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
                height: 25,
                color: Colors.blue,
                thickness: 1.0,
              ),

              Text(
                  "Dieta", style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),


              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: RadioListTile<String>(
                      title: Text(_TIPO_DIETA1, style: TextStyle(color: Colors.blue,fontSize: 15, fontWeight: FontWeight.bold)),
                      value: _TIPO_DIETA1,
                      activeColor: Colors.yellow,
                      groupValue: _tipoDietaSelecionada,
                      onChanged: (String value) { setState(() { _tipoDietaSelecionada = value; }); },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RadioListTile<String>(
                      title: Text(_TIPO_DIETA2,style: TextStyle(color: Colors.blue,fontSize: 15, fontWeight: FontWeight.bold)),
                      value: _TIPO_DIETA2,
                      activeColor: Colors.yellow,
                      groupValue: _tipoDietaSelecionada,
                      onChanged: (String value) { setState(() { _tipoDietaSelecionada = value; }); },
                    ),
                  ),
                ],
              ),

              Divider(
                height: 25,
                color: Colors.blue,
                thickness: 1.0,
              ),

              Visibility(
                  visible: _isTipoHarris(),
                  child: Text(_TIPO_DIETA1)
              ),
              Visibility(
                  visible: _isTipoBolso(),
                  child:
                  Column(

                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(children: [
                          Expanded(
                            flex: 3,
                            child:
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "Peso",
                                    prefixIcon: Icon(MdiIcons.weightKilogram),
                                    contentPadding: EdgeInsets.only(left: 50),
                                    labelStyle: TextStyle(color: Colors.blue)),
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                                controller: peso,
                                validator: (value) {
                                  if (_isTipoBolso() && value.isEmpty) {
                                    return _validationMessage("Informe seu peso total.");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(left: 35),
                              child: Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 2),
                                      child:  Icon(MdiIcons.weightLifter, color: Colors.black54, size: 30,)),
                                  Padding(padding: EdgeInsets.only(left: 5),
                                      child:  Text("Kcal/Kg",style: TextStyle(color: Colors.blue, fontSize: 15))),
                                  Padding(padding: EdgeInsets.only(left: 5),
                                    child:  DropdownButton<String>(
                                      value: _dropDownKcal,
                                      iconDisabledColor: Colors.blue,
                                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.blue, fontSize: 13),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _dropDownKcal = newValue;
                                          _dietaEditada = true;
                                        });
                                      },
                                      items: <String>['  ','11', '14', '20', '22', '25', '27', '30', '35', '40', '45' ].map<DropdownMenuItem<String>>((String value) {
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
                        ]),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(children: [
                          Expanded(
                            flex: 3,
                            child:
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "Peso",
                                    prefixIcon: Icon(MdiIcons.weightKilogram),
                                    contentPadding: EdgeInsets.only(left: 50),
                                    labelStyle: TextStyle(color: Colors.blue)),
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                                controller: peso,
                                validator: (value) {
                                  if (_isTipoBolso() && value.isEmpty) {
                                    return _validationMessage("Informe seu peso total.");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(left: 35),
                              child: Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 2),
                                      child:  Icon(MdiIcons.weightLifter, color: Colors.black54, size: 30,)),
                                  Padding(padding: EdgeInsets.only(left: 5),
                                      child:  Text("Kcal/Kg",style: TextStyle(color: Colors.blue, fontSize: 15))),
                                  Padding(padding: EdgeInsets.only(left: 5),
                                    child:  DropdownButton<String>(
                                      value: _dropDownKcal,
                                      iconDisabledColor: Colors.blue,
                                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.blue, fontSize: 13),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _dropDownKcal = newValue;
                                          _dietaEditada = true;
                                        });
                                      },
                                      items: <String>['  ','11', '14', '20', '22', '25', '27', '30', '35', '40', '45' ].map<DropdownMenuItem<String>>((String value) {
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
                        ]),
                      )

                    ],
                  ),





              ),


            ],
          ),
        ),
      ),
    );
  }

  bool _isTipoHarris(){
    if(_tipoDietaSelecionada == _TIPO_DIETA1){
      return true;
    }else{
      return false;
    }
  }
  bool _isTipoBolso(){
    print("isbolso");
    if(_tipoDietaSelecionada == _TIPO_DIETA2){
      print("true");
      return true;
    }else{
      print("false");
      return false;
    }
  }

}