import 'package:flutter/material.dart';

class CalculadoraImcPage extends StatefulWidget {
  CalculadoraImcPage();

  @override
  _CalculadoraImcState createState() => _CalculadoraImcState();
}


class _CalculadoraImcState extends State<CalculadoraImcPage> {
  var peso = TextEditingController();
  var altura = TextEditingController();
  double imc;
  String info = "Resultado aqui";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _limpar() {
    peso.text = "";
    altura.text = "";
    setState(() {
      info = "Info";
    });
  }

  void _calcular() {
    setState(() {
      double al = _converteStringToNUmber(altura.text) / 100;
      double pe = _converteStringToNUmber(peso.text);
      this.imc = pe / (al * al);
      String imcResult = imc.toStringAsFixed(2);
      if (imc < 18.6) {
        this.info = "Seu IMC é de $imcResult e você está abaixo do peso ideal";
      }
      if (imc >= 18.6 && imc < 24.9) {
        this.info = "Seu IMC é de $imcResult e você está no peso ideal";
      }
      if (imc >= 24.9 && imc < 29.9) {
        this.info =
            "Seu IMC é de $imcResult e você está levemente acima do peso";
      }
      if (imc >= 24.9 && imc < 34.9) {
        this.info = "Seu IMC é de $imcResult e você está com obesidade grau I";
      }

      if (imc >= 34.9 && imc < 39.9) {
        this.info = "Seu IMC é de $imcResult e você está com obesidade grau II";
      }
      if (imc >= 40.0) {
        this.info =
            "Seu IMC é de $imcResult e você está com obesidade grau III";
      }
    });
  }

  double _converteStringToNUmber(String valor) {
    return double.parse(valor);
  }

  String _validationMessage(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 35.0, color: Colors.black),
    ).data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Calcular IMC"),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.person,
                        size: 120.0,
                        color: Colors.blueAccent,
                      ),
                      onTap: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onDoubleTap: (){
                        _limpar();
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Peso (KG)",
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                      ),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                      controller: peso,
                      validator: (value) {
                        if (value.isEmpty) {
                          return _validationMessage("Informe seu peso total.");
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Altura (CM)",
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                      ),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                      controller: altura,
                      validator: (value) {
                        if (value.isEmpty) {
                          return _validationMessage("Informe sua altura");
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _calcular();
                            }
                          },
                          child: Text(
                            "Calcular",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Text(
                      info,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.blueAccent, fontSize: 25.0),
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
}
