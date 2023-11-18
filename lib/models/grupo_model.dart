class GrupoModel {
  int? noGrupo;
  String? idMateria;
  String? idMaestro;
  

  GrupoModel(
      {
      this.noGrupo,
      this.idMateria,
      this.idMaestro
      }); //este es un constructor. Sin las llaves son parametros indexados osea que deben estar en ese orden cuando se trabaje con el contructor y los nombrados no importa el orden como en este caso

  factory GrupoModel.fromMap(Map<String,dynamic> map) {
    return GrupoModel(
      noGrupo: map['noGrupo'],
      idMateria: map['idMateria'],
      idMaestro: map['idMaestro']
      );
  }
}