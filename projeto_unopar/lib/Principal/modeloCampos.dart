class Modelo {
  String _nomeLog;
  String _numero;
  String _complemento;
  String _municipio;
  String _estado;
  String _zona;
  String _area;
  String _edificacao;
  String _metrosQuadrados;
  String _responsavel;
  String _url;
  String _id;

  // Parte do Vistoriador
  

  Modelo();
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {

      "nomeLog": this.nomeLog,
      "numero":this.numero,
      "complemento":this.complemento,
      "municipio":this.municipio,
      "estado":this.estado,
      "zona":this.zona,
      "area":this.area,
      "edificacao":this.edificacao,
      "metrosQuadrados":this.metrosQuadrados,
      "responsavel":this.responsavel,
      "urlImagem":this.url,
      "id":this.id,
    };
    return map;
  }

  String get url => _url;
  set url(String value){
    _url = value;
  }

  String get nomeLog => _nomeLog;
  set nomeLog(String value){
    _nomeLog=value;
  }

  String get numero => _numero;
  set numero(String value){
    _numero = value;
  }

  String get complemento => _complemento;
  set complemento(String value){
    _complemento = value;
  }

  String get municipio => _municipio;
  set municipio(String value){
    _municipio = value;
  }

  String get estado => _estado;
  set estado(String value){
    _estado = value;
  }

  String get zona => _zona;
  set zona(String value){
    _zona = value;
  }

  String get area => _area;
  set area(String value){
    _area = value;
  }

  String get edificacao => _edificacao;
  set edificacao(String value){
    _edificacao = value;
  }

  String get metrosQuadrados => _metrosQuadrados;
  set metrosQuadrados(String value){
    _metrosQuadrados = value;
  }

  String get responsavel => _responsavel;
  set responsalvel(String value){
    _responsavel = value;
  }
  
  String get id => _id;
  set id(String value){
    _id = value;
  }
  
}
