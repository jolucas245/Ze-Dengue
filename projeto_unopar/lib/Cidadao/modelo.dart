class Usuario{
  String _cpf;
  String _nome;
  String _telefone;
  String _endereco;
  String _numero;
  String _aniversario;
  String _email;
  String _senha;
  String _escolaridade;
  String _atuacao;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "cpf" : this.cpf,
      "nome" : this.nome,
      "telefone":this.telefone,
      "endereco":this.endereco,
      "numero":this.numero,
      "aniversario":this.aniversario,
      "email":this.email,
      "escolaridade":this.escolaridade,
      "atuacao":this.atuacao,
    };

    return map;
  }

  String get senha => _senha;

  set senha(String value){
    _senha = value;
  }
  String get telefone => _telefone;

  set telefone(String value){
    _telefone = value;
  }
  String get cpf => _cpf;

  set cpf(String value){
    _cpf = value;
  }
  String get numero => _numero;

  set numero(String value){
    _numero = value;
  }
  String get aniversario => _aniversario;

  set aniversario(String value){
    _aniversario = value;
  }
  String get email => _email;

  set email(String value){
    _email = value;
  }
  String get nome => _nome;

  set nome(String value){
    _nome = value;
  }
  String get endereco => _endereco;

  set endereco(String value){
    _endereco = value;
  }
  String get escolaridade => _escolaridade;
  set escolaridade(String value){
    _escolaridade = value;
  }
  String get atuacao => _atuacao;
  set atuacao(String value){
    _atuacao = value;
  }
}