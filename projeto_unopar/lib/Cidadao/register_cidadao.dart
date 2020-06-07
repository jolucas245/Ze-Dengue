import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:projeto_unopar/Animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_unopar/Cidadao/modelo.dart';
import 'package:projeto_unopar/Principal/PrincipalCidadao.dart';

class CidadaoRegister extends StatefulWidget {
  @override
  _CidadaoRegisterState createState() => _CidadaoRegisterState();
}

class _CidadaoRegisterState extends State<CidadaoRegister> {
  // Cores
  Color corPrimaria = Color(0xFFF58524), corSecundaria = Color(0xFFEC407A);

  // Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEnd = TextEditingController();
  TextEditingController _controllerNum = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerAni = TextEditingController();
  

  // Formatar CPF
  var controladorCPF = new MaskedTextController(mask: "000.000.000-00");
  var controladorTel = new MaskedTextController(mask: "00 9 0000-0000");
  // Proximo foco
  final FocusNode _cpf = FocusNode();
  final FocusNode _nomeCompleto = FocusNode();
  final FocusNode _telefone = FocusNode();
  final FocusNode _endereco = FocusNode();
  final FocusNode _dataAni = FocusNode();
  final FocusNode _numero = FocusNode();
  final FocusNode _emailRegister = FocusNode();
  final FocusNode _senhaRegister = FocusNode();

  // Validar 
  final _formKey = GlobalKey<FormState>();
  bool _autoValidarCPF = false;
  bool _autoValidarEmail = false;
  bool _autoValidarSenha = false;
  bool _autoValidarTel = false;
  bool _autoValidarEnd = false;
  bool _autoValidarNum = false;

  // Mostrar senha
  bool senhaVisivel;

  @override
  void initState(){
    senhaVisivel = true;
  }

  // Data 
  DateFormat teste = DateFormat("dd/MM/yyyy");

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha,
    ).then((firebaseUser){
      // Salvar dados do usuario
      Firestore db = Firestore.instance;
      db.collection("usuario-cidadao")
      .document(firebaseUser.user.uid)
      .setData(
        usuario.toMap(),
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrincipalCidadao()));
    })
    .catchError((error){
      print(error.toString());
    });
  }

  // Dropdown
  List<String> _ocorrencias = <String>[
    "Ensino Fundamental Incompleto",
    "Ensino Fundamental Completo",
    "Ensino Médio Incompleto",
    "Ensino Médio Completo",
    "Graduação",
    "Pós-Graduação",
    
  ];
  var selecionadoVal;

  @override
  Widget build(BuildContext context) {

    // App
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  // Simulação de Card com Container
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 30, left: 30, bottom: 5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 690,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: 5,
                          )
                        ]
                      ),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              // CPF 
                              Padding(
                                padding: EdgeInsets.only(top:20, right: 20, left: 20),
                                child: FadeAnimation(1, TextFormField(
                                  autocorrect: true,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.deepOrange),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.pink, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.call_to_action, color: Colors.grey[700],),
                                    labelText: "CPF",
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    )
                                  ),
                                  controller: controladorCPF,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _cpf,
                                  autovalidate: _autoValidarCPF,
                                  validator: (String value){
                                    if(Validator.cpf(value)){
                                      _autoValidarCPF = !_autoValidarCPF;
                                      return 'CPF Inválido';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (term){
                                    _fieldFocus(context, _cpf, _nomeCompleto);
                                  },
                                ),),
                              ),
                              // Nome
                              Padding(
                                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                                child: FadeAnimation(1, TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                        BorderSide(color: Colors.deepOrange),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink, width: 2
                                      ),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    prefixIcon: Icon(Icons.person, color: Colors.grey[700],),
                                    labelText: "Nome Completo",
    
                                    labelStyle: TextStyle(
                                      color: Colors.grey[700]
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _nomeCompleto,
                                  onFieldSubmitted: (term){
                                    _fieldFocus(context, _nomeCompleto, _telefone);
                                  },
                                  validator: _validarNome,
                                  controller: _controllerNome,
                                )),
                              ),
                              // Telefone
                              Padding(
                                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                                child: FadeAnimation(1, TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.deepOrange),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.pink, width: 2),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    prefixIcon: Icon(Icons.phone, color: Colors.grey[700]),
                                    labelText: "Telefone",
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                      ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  focusNode: _telefone,
                                  onFieldSubmitted: (term){
                                    _fieldFocus(context, _telefone, _endereco);
                                  },
                                  controller: controladorTel,
                                  autovalidate: _autoValidarTel,
                                  validator: (value){
                                    if(value.replaceAll(' ', '').length < 12){
                                      _autoValidarTel = !_autoValidarTel;
                                      return "Deve conter 11 dígitos";
                                    }
                                    return null;
                                  }
                                )),
                              ),
                              // Endereco
                              Padding(
                                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                                child: FadeAnimation(1, Row(
                                  children: <Widget>[
                                      Container(   
                                        child: Container(
                                          width: 210,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(color: Colors.deepOrange)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                ),
                                                borderSide: BorderSide(color: Colors.pink, width: 2),
                                              ),
                                              prefixIcon: Icon(Icons.home, color: Colors.grey[700]),
                                              labelText: "Endereço",
                                              labelStyle: TextStyle(color: Colors.grey[700]),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                ),
                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                ),
                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                              ),
                                              hintText: "Rua Monlevade, João Monlevade - MG",
                                              hintStyle: TextStyle(fontSize: 9),
                                            ),
                                            textCapitalization: TextCapitalization.words,
                                            textInputAction: TextInputAction.next,
                                            focusNode: _endereco,
                                            onFieldSubmitted: (term){
                                              _fieldFocus(context, _endereco, _numero);
                                            },
                                            autovalidate: _autoValidarEnd,
                                            validator: (value){
                                              if(value.length == 0){
                                                _autoValidarEnd = !_autoValidarEnd;
                                                return "Coloque um endereço";
                                              }
                                            },
                                            controller: _controllerEnd,
                                          ),
                                        ),
                                      ),
                                      Expanded(   
                                        child: Container(
                                          width: 60,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(color: Colors.deepOrange),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                ),
                                                borderSide: BorderSide(color: Colors.pink, width: 2),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                ),
                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                ),
                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                              ),
                                              hintText: "nº",
                                              hintStyle: TextStyle(color: Colors.grey[700]),
                                            ),
                                            textAlign: TextAlign.center,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            focusNode: _numero,
                                            onFieldSubmitted: (term){
                                              _fieldFocus(context, _numero, _dataAni);
                                            },
                                            autovalidate: _autoValidarNum,
                                            validator: (value){
                                              if(value.length == 0){
                                                _autoValidarNum = !_autoValidarNum;
                                                return "Em branco";
                                              }
                                            },
                                            controller: _controllerNum,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),),
                              ),
                              // Data de Nascimento
                              Padding(
                                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                                child: FadeAnimation(1, DateTimeField(
                                  format: teste,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.deepOrange)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.pink, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.cake, color: Colors.grey[700]),
                                    labelText: "Data de Nascimento",
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                  ),
                                  focusNode: _dataAni,
                                  onFieldSubmitted: (term){
                                    _fieldFocus(context, _dataAni, _emailRegister);
                                  },
                                  onShowPicker: (context, currentValue){
                                    return showDatePicker(
                                      context: context, 
                                      
                                      initialDate: DateTime.now(), 
                                      firstDate: DateTime(1930), 
                                      lastDate: DateTime(2021),
                                    );
                                  },
                                  controller: _controllerAni,
                                ))
                              ),

                              // TextField para Email
                              Padding(
                                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                                child: FadeAnimation(1, TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.deepOrange),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.pink, width: 2
                                        ),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    prefixIcon: Icon(Icons.email, color: Colors.grey[700],),
                                    labelText: "E-mail",
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  focusNode: _emailRegister,
                                  onFieldSubmitted: (term){
                                    _fieldFocus(context, _emailRegister, _senhaRegister);
                                  },
                                  autovalidate: _autoValidarEmail, // Validar automatico
                                  validator: (String value){ // validar email
                                    if(Validator.email(value)){
                                      _autoValidarEmail = !_autoValidarEmail;
                                      return "Insira um e-mail válido";
                                    }
                                  },
                                  controller: _controllerEmail,
                                ),),
                              ),
                              // TextField para senha
                              Padding(
                                padding: EdgeInsets.only(top:20, right: 20, left: 20),
                                child: FadeAnimation(2,TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.deepOrange),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Colors.pink, width: 2
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.lock, color: Colors.grey[700],),
                                    labelText: "Senha",
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        senhaVisivel ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey[700],
                                      ), 
                                      onPressed: (){
                                        setState(() {
                                          senhaVisivel = !senhaVisivel;
                                        });
                                      }
                                    )
                                  ),
                                  obscureText: senhaVisivel,
                                  focusNode: _senhaRegister,
                                  autovalidate: _autoValidarSenha,
                                  validator: (value){
                                    if(value.isEmpty){
                                      _autoValidarSenha = !_autoValidarSenha;
                                      return "Preencha este campo";
                                    }else if(value.length <= 5){
                                      _autoValidarSenha = !_autoValidarSenha;
                                      return "Deve conter mais de 5 dígitos";
                                    }
                                  },
                                  controller: _controllerSenha,
                                ),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: FadeAnimation(2.5, Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:<Widget>[ 
                                    Icon(Icons.school, color: Colors.grey[700]),
                                    DropdownButton(
                                    items: _ocorrencias.map((value)=>DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    )).toList(),
                                    onChanged: (selecionado){
                                      setState(() {
                                        selecionadoVal = selecionado;
                                      });
                                    },
                                    value: selecionadoVal,
                                    hint: Text("Escolaridade", style: TextStyle(color: Colors.grey[700])),
                                    
                                    elevation: 2,
                                    isExpanded: false,
                                    underline: Container(
                                      color: Colors.deepOrange, height: 1,
                                    ),
                                    ), 
                                  ],
                                ),
                              )),
                              Padding(
                                padding: EdgeInsets.only(right: 30, left: 30, top: 20),
                                child: FadeAnimation(2.5, NiceButton(
                                  gradientColors: [corSecundaria, corPrimaria],
                                  onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      Scaffold
                                        .of(context)
                                        .showSnackBar(SnackBar(content: Text('Dados processados com sucesso.')));

                                      String cpf = controladorCPF.text;
                                      String telefone = controladorTel.text;
                                      String endereco = _controllerEnd.text;
                                      String numero = _controllerNum.text;
                                      String aniversario = _controllerAni.text;
                                      String nome = _controllerNome.text;
                                      String email = _controllerEmail.text;
                                      String senha = _controllerSenha.text;
   
                                      Usuario usuario = Usuario();
                                      usuario.nome = nome;
                                      usuario.cpf = cpf;
                                      usuario.telefone = telefone;
                                      usuario.endereco = endereco;
                                      usuario.numero = numero;
                                      usuario.aniversario = aniversario;
                                      usuario.email = email;
                                      usuario.senha = senha;
                                      usuario.escolaridade = selecionadoVal;
                                      usuario.atuacao = "Cidadão";
                                      _cadastrarUsuario(usuario);
                                    }
                                    
                                  },
                                  text: "Registrar",
                                  elevation: 10,
                                  radius: 30,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  )
                ],
              ),
            )));
  }
}

_fieldFocus(BuildContext context, FocusNode atualFocus, FocusNode proximoFocus){
  atualFocus.unfocus();
  FocusScope.of(context).requestFocus(proximoFocus);
}
String _validarNome(String value) {
  String patttern = r'(^[a-zA-ZáÁéÉíÍóÓúÚãÃâÂêÊôÔçÇ ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Informe o nome";
  } else if (!regExp.hasMatch(value)) {
    return "O nome deve conter caracteres de a-z ou A-Z";
  }
  return null;
}
