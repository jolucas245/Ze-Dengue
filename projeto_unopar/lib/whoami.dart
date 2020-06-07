import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:projeto_unopar/Animations/boucypageroute.dart';
import 'package:projeto_unopar/Cidadao/home_cidadao.dart';
import 'package:projeto_unopar/Vistoriador/home_vistoriador.dart';
import 'icones_icons.dart';


class Whoami extends StatefulWidget {

  @override
  _WhoamiState createState() => _WhoamiState();
}

class _WhoamiState extends State<Whoami> {
  // Cores para botoes
  Color corPrimaria = Color(0xFFF58524), corSecundaria = Color(0xFFEC407A);
  Color corTerciaria = Color(0xFF03A9F4), corQuaternaria = Color(0xFF5C6BC0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body:Container(
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Icon(Icones.mosquito, size: 100),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:20, bottom: 20),
                    child: Text(
                      "Entrar como: ",
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: "SpicyRice",

                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NiceButton(
                    radius: 10,
                    onPressed: (){
                      Navigator.push(context, BoucyPageRoute(widget: Cidadao()) );
                    }, 
                    text: "Cidadão", 
                    gradientColors: [corPrimaria, corSecundaria],
                    elevation: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    child: NiceButton(
                      radius: 10,
                      onPressed: (){
                        Navigator.push(context, BoucyPageRoute(widget: Vistoriador()));
                      }, 
                      text: "Vistoriador", 
                      gradientColors: [corTerciaria, corQuaternaria],
                      elevation: 10,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}