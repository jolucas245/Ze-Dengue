import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_unopar/Cidadao/perfilCidadao.dart';
import 'package:projeto_unopar/Principal/FotoUpload.dart';
import 'package:projeto_unopar/whoami.dart';
import 'dart:async';
import 'dart:io';

import 'package:transparent_image/transparent_image.dart';

class PrincipalCidadao extends StatefulWidget {
  @override
  _PrincipalCidadaoState createState() => _PrincipalCidadaoState();
}

class _PrincipalCidadaoState extends State<PrincipalCidadao>{

  // Cores
  Color corPrimaria = Color(0xFFF58524), corSecundaria = Color(0xFFEC407A);

  // Pegar dados
  String _idUserAtual;
  String nome;
  String cpf;
  String telefone;
  String endereco;
  String numero;
  String aniversario;
  String email;
  String escolaridade;
  String atuacao;

  _recuperarDadosUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUserAtual = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuario-cidadao")
    .document(_idUserAtual)
    .get();

    Map<String, dynamic> dados = snapshot.data;
    setState(() {
      nome = dados['nome'];
      cpf = dados['cpf'];
      telefone = dados['telefone'];
      endereco = dados['endereco'];
      numero = dados['numero'];
      aniversario = dados['aniversario'];
      email = dados['email'];
      escolaridade = dados['escolaridade'];
      atuacao = dados['atuacao'];
    });
  }
  
  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
  }

  // Sair
  _sairUser()async {
    FirebaseAuth auth = FirebaseAuth.instance; // Instancia o FirebaseAuth
    await auth.signOut(); // Await que aguarda a saída do usuário
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => Whoami()) // Retorna à tela inicial do app
    ); 
  }
  
  // Pegar imagem

  File _imagem;
  Future _recuperarImagem(bool daCamera) async{
    File imagemSelecionada;
    if(daCamera == true){
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
    }else{
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _imagem = imagemSelecionada;
    });
  }

  // URL
  String urlImagem;
  _urlListen() async {
    Firestore db = Firestore.instance;
    db.collection("fotos").snapshots().listen(
      (snapshot){
        for(DocumentSnapshot item in snapshot.documents){
          var dados = item.data;
          setState(() {
            urlImagem = dados["urlImagem"];
          });
        }
      }
    );
  }

  Map<String, dynamic> dadosFormat;
  _recuperarInfos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection("fotos").getDocuments();
    for(DocumentSnapshot item in querySnapshot.documents){
      var dados = item.data;
      setState(() {
        dadosFormat = dados;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _recuperarDadosUser();
    _urlListen();
    _recuperarInfos();
    List<String> nomeUser = nome.toString().trim().split(' ');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[corPrimaria, corSecundaria]
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(1.0, 0.0),
                    blurRadius: 2,
                  )
                ]
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      radius: 45,
                      child: Image.asset("images/cidadao.png")
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "${nomeUser[0]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19
                      ),
                    ),
                  ],
                )
              ),
            ),
            ListTile(
              title: Text("Meu Perfil"),
              leading: Icon(Icons.person,),
              trailing: Icon(Icons.arrow_upward,),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilCidadao(
                nome, 
                cpf,
                telefone, 
                endereco,
                numero,
                aniversario, 
                email,
                escolaridade,
                atuacao,
              ))),
            ),
            Divider(),
            ListTile(
              title: Text("Fechar aba"),
              trailing: Icon(Icons.close,),
              onTap: () => Navigator.of(context).pop(context),
            ),
            SizedBox(height: 340,),
            Divider(),
            ListTile(
              title: Text("Sair da conta atual"),
              leading: Icon(Icons.power_settings_new, color: Colors.red),
              onTap: () => _sairUser(),
            ),
          ],
        ),
      ),
      body: Stack(
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("fotos").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    )
                  );
                }else{
                  return ListView.separated(
                    itemBuilder: (context, index){
                      return GestureDetector(
                          onTap: () => abrirDialog(
                            context, 
                            dadosFormat["responsavel"],
                            dadosFormat["nomeLog"],
                            dadosFormat["numero"],
                            dadosFormat["complemento"],
                            dadosFormat["municipio"],
                            dadosFormat["estado"],
                            dadosFormat["zona"],
                            dadosFormat["area"],
                            dadosFormat["edificacao"],
                            dadosFormat["metrosQuadrados"],
                            ),
                          child: Container(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            width: 300,
                            height: 250,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                              ),
                              elevation: 10,
                              semanticContainer: true,
                              borderOnForeground: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage, 
                                image: snapshot.data.documents[index].data["urlImagem"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 10,
                      thickness: 0,
                    ),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            )
          ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.camera_alt),
        onPress: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UploadFoto()));
        },
      )
    );
  }
}// Não apaga

abrirDialog(
  BuildContext context, 
  String nomeResponsavel, 
  String nomeLog,
  String numero,
  String complemento,
  String municipio, 
  String estado,
  String zona,
  String area,
  String edificacao,
  String metrosQuadrados,  
) async{

  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Informações", textAlign: TextAlign.center,),
        content: Stack(
          children: <Widget>[
            IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Divider(color: Colors.deepOrange,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Responsável\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$nomeResponsavel",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Nome do Logradouro\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$nomeLog ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            ),
                            TextSpan(
                              text: "Nº ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )
                            ),
                            TextSpan(
                              text: "$numero",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 15,
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Complemento\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$complemento",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.map),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Município\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$municipio",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            ),
                          ]
                        ),
                      ),
                      VerticalDivider(color: Colors.grey,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "UF\n",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              )
                            ),
                            TextSpan(
                              text: "$estado",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            ),
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.my_location),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Zona\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$zona",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_city),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Área\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$area",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.format_line_spacing),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Edificação\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$edificacao",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Icon(Icons.aspect_ratio),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Área em m² \n",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black
                              )
                            ),
                            TextSpan(
                              text: "$metrosQuadrados",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepOrange
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      );
    }
  );
}
