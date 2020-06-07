import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:projeto_unopar/Animations/animations.dart';
import 'package:projeto_unopar/Cidadao/modelo.dart';
import 'package:projeto_unopar/Principal/PrincipalCidadao.dart';

class CidadaoLogin extends StatefulWidget {
  @override
  _CidadaoLoginState createState() => _CidadaoLoginState();
}

class _CidadaoLoginState extends State<CidadaoLogin> {
  // Cores
  Color corPrimaria = Color(0xFFF58524), corSecundaria = Color(0xFFEC407A);

  // Proximo foco
  final FocusNode _emailLogin = FocusNode();
  final FocusNode _senhaLogin = FocusNode();

  // Mostrar senha
  bool senhaVisivel;
  void initState() {
    //_verificarUsuarioLogado();
    senhaVisivel = true;
  }

  // Autenticação do usuario
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    ).then((firebaseUser) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Login realizado com sucesso!')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrincipalCidadao()));
    }).catchError((error){
      Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text('Erro. Verifique suas informações.')));
      print(error);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 30, left: 30, bottom: 5),
                    child: Container(
                        padding: EdgeInsets.all(5),
                        height: 590,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                blurRadius: 5,
                              )
                            ]),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30, right: 20, left: 20),
                                child: FadeAnimation(
                                  1,
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _controllerEmail,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.deepOrange),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.grey[700],
                                        ),
                                        labelText: "E-mail",
                                        labelStyle:
                                            TextStyle(color: Colors.grey[800])),
                                    textInputAction: TextInputAction.next,
                                    focusNode: _emailLogin,
                                    onFieldSubmitted: (term) {
                                      _fieldFocus(
                                          context, _emailLogin, _senhaLogin);
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 32, right: 20, left: 20),
                                child: FadeAnimation(
                                  2,
                                  TextField(
                                    keyboardType: TextInputType.visiblePassword,
                                    controller: _controllerSenha,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.deepOrange),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.pink, width: 2),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.grey[700],
                                        ),
                                        labelText: "Senha",
                                        labelStyle:
                                            TextStyle(color: Colors.grey[800]),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              senhaVisivel
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey[700]),
                                          onPressed: () {
                                            setState(() {
                                              senhaVisivel = !senhaVisivel;
                                            });
                                          },
                                        )),
                                    obscureText: senhaVisivel,
                                    focusNode: _senhaLogin,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30, left: 30, top: 20),
                                child: FadeAnimation(
                                  2.5,
                                  NiceButton(
                                    gradientColors: [
                                      corSecundaria,
                                      corPrimaria
                                    ],
                                    onPressed: () {
                                      String email = _controllerEmail.text;
                                      String senha = _controllerSenha.text;

                                      Usuario usuario = Usuario();
                                      usuario.email = email;
                                      usuario.senha = senha;
                                      _logarUsuario(usuario);
                                    },
                                    text: "Entrar",
                                    elevation: 10,
                                    radius: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            )));
  }
}

_fieldFocus(
    BuildContext context, FocusNode atualFocus, FocusNode proximoFocus) {
  atualFocus.unfocus();
  FocusScope.of(context).requestFocus(proximoFocus);
}
