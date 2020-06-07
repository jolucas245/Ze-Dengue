import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'modeloCampos.dart';

class UploadFoto extends StatefulWidget {
  @override
  _UploadFotoState createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {

  // Recuperando dados
  TextEditingController _nomeLog = TextEditingController();
  TextEditingController _numero = TextEditingController();
  TextEditingController _complemento = TextEditingController();
  TextEditingController _municipio = TextEditingController();
  TextEditingController _estado = TextEditingController();
  TextEditingController _metrosQuadrados = TextEditingController();
  TextEditingController _nomeResponsavel = TextEditingController();

  // Recuperar imagem
  File _imagem;
  String urlImagemRecuperada;
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

  // Upload da Imagem
  Modelo modelo = Modelo();
  Future _uploadImagem(Modelo modelo) async {
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
      .child("fotos")
      .child(nomeImagem + ".jpg");

    StorageUploadTask task = arquivo.putFile(_imagem);
    final snapshot = await task.onComplete;     
    modelo.url = await snapshot.ref.getDownloadURL();

    modelo.id = nomeImagem + ".jpg";

    // Coloca os dados da imagem no Cloud FireStore
    Firestore db = Firestore.instance;
    await db.collection("fotos")
    .document(nomeImagem + ".jpg")
    .setData(modelo.toMap());
  }

  // Radio
  String _escolhaZona;
  String _escolhaArea;
  String _escolhaEdificacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Upload da Foto"),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.beenhere),
            onPressed: () async {
              if(_imagem == null){
                Navigator.pop(context);
              }else{

                Modelo modelo = new Modelo();
                String nomeLog = _nomeLog.text;
                String numero = _numero.text;
                String complemento = _complemento.text;
                String municipio = _municipio.text;
                String estado = _estado.text;
                String metrosQuadrados = _metrosQuadrados.text;
                String nomeResponsavel = _nomeResponsavel.text;

                
                modelo.nomeLog = nomeLog;
                modelo.numero = numero;
                modelo.complemento = complemento;
                modelo.municipio = municipio;
                modelo.estado = estado;
                modelo.metrosQuadrados = metrosQuadrados;
                modelo.responsalvel = nomeResponsavel;
                modelo.edificacao = _escolhaEdificacao;
                modelo.area = _escolhaArea;
                modelo.zona = _escolhaZona;
    
                await _uploadImagem(modelo);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    width: 300,
                    height: 200,
                    //color: Colors.black,
                    child: Card(
                      elevation: 10,
                      child: (_imagem!=null)?Image.file(_imagem, fit: BoxFit.fill,):Text("\n\n\n\n\n\nSelecione uma imagem da galeria", textAlign: TextAlign.center,),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.only(top:20, bottom:10, left: 10, right: 10),
                    elevation: 10,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Container(
                                  width: 250,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Nome do Logradouro"
                                    ),
                                    controller: _nomeLog,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Número",
                                    ),
                                    controller: _numero,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Container(
                                  width: 150,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Complemento"
                                    ),
                                    controller: _complemento,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Município",
                                    ),
                                    controller: _municipio,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "UF",
                                    ),
                                    controller: _estado,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: "Zona Rural",
                                groupValue: _escolhaZona,
                                onChanged: (String escolha){
                                  setState(() {
                                    _escolhaZona = escolha;
                                  });
                                },
                              ),
                              Text("Zona Rural"),
                              Radio(
                                value: "Zona Urbana",
                                groupValue: _escolhaZona,
                                onChanged: (String escolha){
                                  setState(() {
                                    _escolhaZona = escolha;
                                  });
                                },
                              ),
                              Text("Zona Urbana"),
                            ],
                          ),
                        ),
                        Divider(thickness: 1,),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: "Residencial",
                                groupValue: _escolhaArea,
                                onChanged: (String escolha){
                                  setState(() {
                                    _escolhaArea = escolha;
                                  });
                                },
                              ),
                              Text("Residencial"),
                              Radio(
                                value: "Comercial",
                                groupValue: _escolhaArea,
                                onChanged: (String escolha){
                                  setState(() {
                                    _escolhaArea = escolha;
                                  });
                                },
                              ),
                              Text("Comercial"),
                              Radio(
                                value: "Industrial",
                                groupValue: _escolhaArea,
                                onChanged: (String escolha){
                                  setState(() {
                                    _escolhaArea = escolha;
                                  });
                                },
                              ),
                              Text("Industrial"),
                            ],
                          ),
                        ),
                        Divider(thickness: 1,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            children: <Widget>[
                              Text("Terreno", style: TextStyle(fontSize: 19, color: Colors.grey[600]),),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value:"Terreno Vazio",
                                    groupValue: _escolhaEdificacao,
                                    onChanged: (String escolha){
                                      setState(() {
                                        _escolhaEdificacao = escolha;
                                      });
                                    },
                                  ),
                                  Text("Vazio"),
                                  Radio(
                                    value:"Edificação Baixa",
                                    groupValue: _escolhaEdificacao,
                                    onChanged: (String escolha){
                                      setState(() {
                                        _escolhaEdificacao = escolha;
                                      });
                                    },
                                  ),
                                  Text("Baixo"),
                                  Radio(
                                    value:"Edificação Alta",
                                    groupValue: _escolhaEdificacao,
                                    onChanged: (String escolha){
                                      setState(() {
                                        _escolhaEdificacao = escolha;
                                      });
                                    },
                                  ),
                                  Text("Alto")
                                ],
                              ),
                            ],
                          )
                        ),
                        Divider(thickness: 1,),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Container(
                                  width: 100,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Área em m²"
                                    ),
                                    controller: _metrosQuadrados,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Nome do Responsável",
                                    ),
                                    controller: _nomeResponsavel,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.ellipsis_search,
        elevation: 5,
        children: [
          SpeedDialChild(
            child: Icon(Icons.photo),
            label: "Enviar foto da galeria",
            onTap: (){
              _recuperarImagem(false);
            },
            backgroundColor: Colors.deepOrange
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            label: "Tirar uma foto",
            backgroundColor: Colors.pink,
            onTap: (){
              _recuperarImagem(true);
            },
          )
        ]
      ),
    );
  }
}