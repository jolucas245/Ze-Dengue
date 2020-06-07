import 'package:flutter/material.dart';
import 'package:projeto_unopar/Animations/animations.dart';
import 'login_vistoriador.dart' as loginVistoriador;
import 'register_vistoriador.dart' as registerVistoriador;


class Vistoriador extends StatefulWidget {
  @override
  _VistoriadorState createState() => _VistoriadorState();
}

class _VistoriadorState extends State<Vistoriador> with SingleTickerProviderStateMixin {

  Color corTerciaria = Color(0xFF03A9F4), corQuaternaria = Color(0xFF5C6BC0);
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
                  colors: <Color>[corTerciaria, corQuaternaria])),
          ),
          title: Text("Zer@ Dengue - Vistoriador"),
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
              loginVistoriador.VistoriadorLogin(),
              registerVistoriador.VistoriadorRegister(),
            ],
          ),
        ],
      )
    );
  }
}