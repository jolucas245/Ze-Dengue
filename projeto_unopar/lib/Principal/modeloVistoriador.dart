class ModeloVistoriador{
  String _login;
  String _nomeVistoriador;
  String _dataRegisto;
  String _horaRegistro;
  String _status;
  String _diagnostico;
  String _proximoMonitoriamento;

  ModeloVistoriador();
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
       // Do vistoriador
       "login":this.login,
       "nomeVistoriador":this.nomeVistoriador,
       "dataRegistro":this.dataRegistro,
       "horaRegistro":this.horaRegistro,
       "status":this.status,
       "diagnostico":this.diagnostico,
       "proximoMonitoramento":this.proximoMonitoramento,
    };
    return map;
  }
  String get login => _login;
  set login(String value){
    _login = value;
  }

  String get nomeVistoriador => _nomeVistoriador;
  set nomeVistoriador(String value){
    _nomeVistoriador = value;
  }

  String get dataRegistro => _dataRegisto;
  set dataRegistro(String value){
    _dataRegisto = value;
  }

  String get horaRegistro => _horaRegistro;
  set horaRegistro(String value){
    _horaRegistro = value;
  }

  String get status => _status;
  set status(String value){
    _status = value;
  }

  String get diagnostico => _diagnostico;
  set diagnostico(String value){
    _diagnostico = value;
  }

  String get proximoMonitoramento => _proximoMonitoriamento;
  set proximoMonitoramento(String value){
    _proximoMonitoriamento = value;
  }
}