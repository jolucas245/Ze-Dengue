import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:projeto_unopar/Vistoriador/perfilVistoriador.dart';
import 'package:projeto_unopar/whoami.dart';
import 'package:transparent_image/transparent_image.dart';

import 'modeloVistoriador.dart';

class PrincipalVistoriador extends StatefulWidget {
  @override
  _PrincipalVistoriadorState createState() => _PrincipalVistoriadorState();
}

class _PrincipalVistoriadorState extends State<PrincipalVistoriador> {
  
  // Cores
  Color corTerciaria = Color(0xFF03A9F4), corQuaternaria = Color(0xFF5C6BC0);
  
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
    DocumentSnapshot snapshot = await db.collection(("usuario-vistoriador"))
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
  _sairUser()async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Whoami()));
  }

  @override
  void initState() { 
    super.initState();
    _recuperarDadosUser();
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
                  colors: <Color>[corTerciaria, corQuaternaria]
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
                      child: Image.asset("images/vistoriador.png", height: 72,),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "${nomeUser[0]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19
                      )
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("Meu Perfil"),
              leading: Icon(Icons.person,),
              trailing: Icon(Icons.arrow_upward,),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilVistoriador(
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
            // SingleChildScrollView(
            //   child: Container(
            //     child: Image.network(urlImagem),
            //   ),
            // )
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
                              child: Stack(
                                children: <Widget>[
                                  FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage, 
                                    image: snapshot.data.documents[index].data["urlImagem"],
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: MediaQuery.of(context).size.width / 100,
                                    left: -16,
                                    child: RaisedButton(
                                      onPressed: () => dialogVistoriador(context),
                                      color: Colors.green,
                                      shape: CircleBorder(),
                                      splashColor: Colors.greenAccent,
                                      child: Icon(
                                        Icons.info_outline
                                      ),
                                    ),
                                  )
                                ],
                              )
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
    );
  }
  dialogVistoriador(BuildContext context){

    // Basics
    TextEditingController login = TextEditingController();
    TextEditingController nome = TextEditingController();

    // Data
    DateFormat teste = DateFormat("dd/MM/yyyy");
    TextEditingController dataRegistro = TextEditingController();

    // Hora
    DateTime hora = DateTime.now();

    // Status
    String status;

    // Diagnostico
    TextEditingController diagnostico = TextEditingController();

    // Proximo Monitoramento 
    TextEditingController proximoMonitoramento = TextEditingController();

    _enviarInformacoes(ModeloVistoriador modeloVistoriador)async{
      Firestore db = Firestore.instance;
      String idImagem;
      QuerySnapshot querySnapshot = await db.collection("fotos").getDocuments();
      for(DocumentSnapshot item in querySnapshot.documents){
        var dados = item.data;
        setState(() {
          idImagem = dados["id"];
        });
      }
      db.collection("fotos").document(idImagem).updateData(modeloVistoriador.toMap()).then(
        (deu){
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("A análise foi enviada"),),
          );
          Navigator.pop(context);
        }
      );

    }

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Dados do Monitoramento", textAlign: TextAlign.center,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: StatefulBuilder(
             builder: (BuildContext context, StateSetter setState) {
             return SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        Divider(color: Colors.blue),
                        Container(
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue)
                              ),
                              labelText: "Email",
                            ),
                            controller: login,
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: "Nome completo",
                            ),
                            controller: nome,
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 40,
                          child: DateTimeField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              labelText: "Data de Registro",
                            ),
                            controller: dataRegistro,
                            format: teste,
                            onShowPicker: (context, currentValue){
                              return showDatePicker(
                                context: context, 
                                
                                initialDate: DateTime.now(), 
                                firstDate: DateTime(1930), 
                                lastDate: DateTime(2021),
                              );
                            },
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Hora do Registro:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                                ),
                              ),
                              TimePickerSpinner(
                                is24HourMode: true,
                                normalTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                                highlightedTextStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                                spacing: 0,
                                alignment: Alignment.center,
                                itemHeight: 20,
                                isForce2Digits: true,
                                onTimeChange: (time){
                                  hora = time;
                                },
                              ),
                            ],
                          )
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text("Status"),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: "Confirma o foco", 
                                    groupValue: status, 
                                    onChanged: (String escolha){
                                      setState(() {
                                        status = escolha;
                                      });
                                    },
                                  ),
                                  Text("Confirma o foco"),
                                  Radio(
                                    value: "Limpo", 
                                    groupValue: status, 
                                    onChanged: (String escolha){
                                      setState(() {
                                        status = escolha;
                                      });
                                    },
                                  ),
                                  Text("Limpo"),
                                ],
                              )
                            ],
                          )
                        ),
                        Divider(),
                        Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: "Diagnóstico da visita",
                              hintText: "Dê uma descrição clara e objetiva do local mencionado",
                            ),
                            maxLines: null,
                            controller: diagnostico,
                          ),
                        ),
                        Divider(),
                        Container(
                          child:DateTimeField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              labelText: "Próximo Monitoramento",
                            ),
                            controller: proximoMonitoramento,
                            format: teste,
                            onShowPicker: (context, currentValue){
                              return showDatePicker(
                                context: context, 
                                
                                initialDate: DateTime.now(), 
                                firstDate: DateTime(1930), 
                                lastDate: DateTime(2021),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
            ),
            );},
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                ModeloVistoriador modeloVistoriador = ModeloVistoriador();

                modeloVistoriador.login = login.text;
                modeloVistoriador.nomeVistoriador = nome.text;
                modeloVistoriador.dataRegistro = dataRegistro.text;
                modeloVistoriador.horaRegistro = hora.toString();
                modeloVistoriador.status = status;
                modeloVistoriador.diagnostico = diagnostico.text;
                modeloVistoriador.proximoMonitoramento = proximoMonitoramento.text;


                _enviarInformacoes(modeloVistoriador);
              }, 
              child: Text("Enviar Análise", style: TextStyle(fontSize: 15),),
            )
          ],
        );
      }
    );
  } // Dialog
}

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
){

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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                          ),
                      ],
                    ),
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

