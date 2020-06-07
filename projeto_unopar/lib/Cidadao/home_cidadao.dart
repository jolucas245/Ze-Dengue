import 'package:flutter/material.dart';
import 'login_cidadao.dart' as loginCidadao;
import 'register_cidadao.dart' as registerCidadao;

class Cidadao extends StatefulWidget {
  @override
  _CidadaoState createState() => _CidadaoState();
}

class _CidadaoState extends State<Cidadao> with SingleTickerProviderStateMixin {

  Color corPrimaria = Color(0xFFF58524), corSecundaria = Color(0xFFEC407A);

  TabController controller;
  @override
  void initState() {
    controller = TabController(vsync: this, length: 2,);
    super.initState();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[corPrimaria, corSecundaria])),
          ),
          title: Text("Zer@ Dengue - Cidadão"),
          bottom: TabBar(
            controller: controller,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.person_add)),
            ]
          ),
        ),
      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: controller,
            children: <Widget>[
              loginCidadao.CidadaoLogin(),
              registerCidadao.CidadaoRegister(),
            ],
          ),
        ],
      )
    );
  }
}