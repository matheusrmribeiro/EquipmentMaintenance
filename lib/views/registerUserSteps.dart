import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../classes/registerSteps.dart';
import '../widgets/customDropdownButtonFormField.dart';
import '../widgets/customTextFormField.dart';
import '../bloc/blocRegisterUser.dart';

class StepOne extends RegisterSteps {
  StepOne(this.bloc);

  final BlocRegisterUser bloc;
  final TextEditingController keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: bloc.outName,
                  builder: (context, snapshot) {
                    return CTextFormField(
                      initialValue: bloc.dataObject.name,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      hintText: '',
                      labelText: 'Nome completo',
                      validator: (value){ return value == "" ? "Obrigatório!" : null;},
                      onSaved: (value) => bloc.dataObject.name = value,
                    );
                  }
                ),
                StreamBuilder(
                  stream: bloc.outEmail,
                  builder: (context, snapshot) {
                    return CTextFormField(
                      initialValue: bloc.dataObject.email,
                      keyboardType: TextInputType.emailAddress,        
                      maxLength: 50,   
                      hintText: 'exemplo@exemplo.com.br',
                      labelText: 'Email',
                      validator: (value){ return value == "" ? "Obrigatório!" : null;},
                      onSaved: (value) => bloc.dataObject.email = value,
                    );
                  }
                ),
                StreamBuilder(
                  stream: bloc.outKey,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      Container();

                    keyController.text = bloc.dataObject.key;
                    return CTextFormField(
                      keyboardType: TextInputType.text,  
                      controller: keyController,
                      maxLength: 80,         
                      hintText: 'Prometo não olhar!',
                      labelText: 'Senha',
                      validator: (value){ return value == "" ? "Obrigatório!" : null;},
                      onSaved: (value) => bloc.dataObject.key = value,
                    );
                  }
                ),
                StreamBuilder(
                  stream: bloc.outKey,
                  builder: (context, snapshot) {
                    return CTextFormField(
                      initialValue: bloc.dataObject.key,
                      keyboardType: TextInputType.text,  
                      maxLength: 80,         
                      hintText: 'Prometo não olhar!',
                      labelText: 'Digite a senha novamente',
                      validator: (value){ 
                        if (value == "")
                          return "Obrigatório!";
                        else if (value != keyController.text)
                          return "A confirmação de senha não confere!";
                        else
                          return null;
                      },
                    );
                  }
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}

class StepTwo extends RegisterSteps {
  StepTwo(this.bloc);

  final BlocRegisterUser bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: bloc.outState,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container();

                return CDropdownButtonFormField<String>(
                  hint: Text("Estado"),
                  value: snapshot.data,
                  items: bloc.listStates.map((item) {
                    print('estado ${item.sigla}');
                    return DropdownMenuItem(
                      value: item.sigla,
                      child: Row(children: <Widget>[Text(item.nome)]),
                    );
                  }).toList(),
                  onChanged: bloc.inState,
                  validator: (value){
                    final state = value??""; 
                    return ((state == "") || (state == "XX"))
                      ? "Obrigatório!" 
                      : null;
                  },
                  onSaved: (value) => bloc.dataObject.state = value.toString(),
                );
              }
            ),
            StreamBuilder(
              stream: bloc.outCity,
              builder: (context, snapshot) {
                return CDropdownButtonFormField<String>(
                  hint: Text("Cidade"),
                  value: snapshot.data,
                  items: bloc.listCities.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Row(children: <Widget>[Text(item)]),
                    );
                  }).toList(),
                  onChanged: bloc.inCity,
                  validator: (value){ 
                    final city = value??"";
                    return ((city == "") || (city == "Selecione uma cidade")) 
                      ? "Obrigatório!" 
                      : null;
                  },
                  onSaved: (value) => bloc.dataObject.city = value.toString(),
                );
              }
            ),
          ],
        ),
      )
    );
  }
}