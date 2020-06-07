import 'package:flutter/material.dart';
import 'package:projeto_unopar/Principal/PrincipalVistoriador.dart';
import 'modelo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:projeto_unopar/Animations/animations.dart';

class VistoriadorLogin extends StatefulWidget {
  @override
  _VistoriadorLoginState createState() => _VistoriadorLoginState();
}

class _VistoriadorLoginState extends State<VistoriadorLogin> {
  
  //Cores
  Color corTerciaria = Color(0xFF03A9F4), corQuaternaria = Color(0xFF5C6BC0);
  
  // Proximo fofo
  final FocusNode _emailLogin = FocusNode();
  final FocusNode _senhaLogin = FocusNode();

  // Mostrar senha
  bool senhaVisivel;
  void initState(){
    senhaVisivel = true;
  }
  
  // Autenticação do usuario
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha,
    ).then((firebaseUser){
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Login realizado com sucesso!')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrincipalVistoriador()));
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
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, right: 30, left: 30, bottom:5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 590,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0,0,0,0.3),
                        blurRadius: 5,
                      )
                    ]),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                          child: FadeAnimation(1, TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue)
                              ), 
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(Icons.email, color: Colors.grey[700]),
                              labelText: "E-mail",
                              labelStyle: TextStyle(color: Colors.grey[800])
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _emailLogin,
                            onFieldSubmitted: (term){
                              _fieldFocus(context, _emailLogin, _senhaLogin);
                            },
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                          child: FadeAnimation(1, TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _controllerSenha,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue)
                              ), 
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                              labelText: "Senha",
                              labelStyle: TextStyle(color: Colors.grey[800]),
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
                              )
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _senhaLogin,
                            obscureText: senhaVisivel,
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right:30, left: 30, top: 20),
                          child: FadeAnimation(2.5, NiceButton(
                            gradientColors: [
                              corQuaternaria,
                              corTerciaria,
                            ],
                            onPressed: (){
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
                          )),
                        )
                        
                      ],
                    )
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

_fieldFocus(context, FocusNode atualFoco, FocusNode proximoFoco){
  atualFoco.unfocus();
  FocusScope.of(context).requestFocus(proximoFoco);
}