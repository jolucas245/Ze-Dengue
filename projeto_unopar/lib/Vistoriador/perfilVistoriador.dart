import 'package:flutter/material.dart';

class PerfilVistoriador extends StatefulWidget {
  
  String nome;
  String cpf;
  String telefone;
  String endereco;
  String numero;
  String aniversario;
  String email;
  String escolaridade;
  String atuacao;

  PerfilVistoriador(
    this.nome,
    this.cpf,
    this.telefone,
    this.endereco,
    this.numero,
    this.aniversario,
    this.email,
    this.escolaridade,
    this.atuacao,
  );
  @override
  _PerfilVistoriadorState createState() => _PerfilVistoriadorState();
}

class _PerfilVistoriadorState extends State<PerfilVistoriador> {
  Color corTerciaria = Color(0xFF03A9F4), corQuaternaria = Color(0xFF5C6BC0);

  
  @override
  Widget build(BuildContext context) {
    List<String> nomeUser = widget.nome.split(' ');
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[corTerciaria, corQuaternaria]
            )
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text("Meu Perfil", style: TextStyle(color: Colors.white),),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.of(context).pop(context)),
      ),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                 gradient: LinearGradient(colors: <Color>[corTerciaria, corQuaternaria]),
                 boxShadow: <BoxShadow>[
                   BoxShadow(
                     color: Colors.black,
                     offset: Offset(-0.5, 1),
                     blurRadius: 10,
                   )
                 ],
                 borderRadius: BorderRadius.only(
                   bottomLeft: Radius.circular(25),
                   bottomRight: Radius.circular(25)
                 )
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(1, 2),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Image.asset("images/vistoriador.png", scale: 6,),
                  ),
                  SizedBox(height: 16,),
                  Text(
                      "${nomeUser[0]} ${nomeUser[1]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.only(top:20, bottom:35, left: 10, right: 10),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        // Nome
                        Padding(
                          padding: EdgeInsets.only(top:20, left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Nome\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                        
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.nome}", 
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
                        ),
                        Divider(thickness: 1,),
                        // CPF
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.call_to_action, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "CPF\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.cpf}", 
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
                        Divider(thickness: 1,),
                        // Telefone
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.phone, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Telefone\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.telefone}", 
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
                        Divider(thickness: 1,),
                        // Endereco
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.home, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Endereço\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.endereco}", 
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                      )
                                    ),
                                    TextSpan(
                                      text:" Nº ", 
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )
                                    ),
                                    TextSpan(
                                      text:"${widget.numero}", 
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                      )
                                    ),
                                  ]
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Aniversário
                        Divider(thickness: 1,),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.cake, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Data de Nascimento\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.aniversario}", 
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
                        Divider(thickness: 1,),
                        // Email
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.alternate_email, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Email\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.email}", 
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
                        Divider(thickness: 1,),
                        // Escolaridade
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.school, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Escolaridade\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.escolaridade}", 
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
                        Divider(thickness: 1,),

                        // Atuação
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.supervisor_account, color: Colors.grey[600]),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Atuação\n",
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"${widget.atuacao}", 
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
                      ],
                    )
                  ],
                ),
              )
            ),
          ],
        ),
        ],
      ),
    );
  }
}