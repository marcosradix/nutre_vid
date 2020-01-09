import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String pacienteTable = "pacienteTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String dataNascimentoColumn = "dataNascimentoColumn";
final String idadeColumn = "idadeColumn";
final String sexoColumn = "sexoColumn";
final String racaColumn = "racaColumn";
final String fotoColumn = "fotoColumn";

//singleton
class PacienteHelper {
  static final PacienteHelper _instace = PacienteHelper.internal();
  factory PacienteHelper() => _instace;
  PacienteHelper.internal();

  //declarar o banco de dados
  Database _db;

  Future<Database> get db async{
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final dataBasePath = await getDatabasesPath(); // retorna o local do db
    final path = join(dataBasePath, "pacientes.db"); //caminho para db

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $pacienteTable ($idColumn INTEGER PRIMARY KEY, "
              "$nomeColumn TEXT, "
              "$dataNascimentoColumn TEXT,"
              "$idadeColumn TEXT, "
              "$sexoColumn TEXT,"
              "$racaColumn  TEXT,"
              "$fotoColumn  TEXT)"
      );
    });
  }

  //salvar contato
  Future<Paciente> savePaciente(Paciente paciente) async{
    Database dbPaciente = await db;
    paciente.id = await dbPaciente.insert(pacienteTable, paciente.toMap());
    return paciente;
  }

  //buscar contato por id
  Future<Paciente> getPaciente(int id) async{
    Database dbPaciente = await db;
    List<Map> maps = await dbPaciente.query(pacienteTable,
        columns: [idColumn, nomeColumn, dataNascimentoColumn, idadeColumn, sexoColumn, racaColumn, fotoColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if(maps.length > 0){
      return Paciente.fromMap(maps.first);
    }else{
      return null;
    }
  }

  //buscar todos
  Future<List> getAllPaciente() async{
    Database dbPaciente = await db;
    List<Map> maps = await dbPaciente.rawQuery("SELECT * FROM $pacienteTable");
    List<Paciente> listPaciente = new List();
    for(Map m in maps){
      listPaciente.add(Paciente.fromMap(m));
    }
    return listPaciente;
  }

  Future<int> deletePaciente(int id) async {
    print("delentando por id: $id");
    Database dbPaciente = await db;
    return await dbPaciente.delete(pacienteTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePaciente(Paciente paciente) async {
    Database dbPaciente = await db;
    return await dbPaciente.update(pacienteTable, paciente.toMap(), where: "$idColumn = ?", whereArgs: [paciente.id]);
  }

  Future<List<Paciente>> getPacientesByName(String name)async {
    Database dbPaciente = await db;

    List listMap = await dbPaciente.rawQuery("SELECT * FROM $pacienteTable WHERE $nomeColumn LIKE '$name%'");
  //  List listMap = await dbPaciente.query(pacienteTable, where: "$nomeColumn LIKE '%\$?%'", whereArgs: [name]);
    List<Paciente> listPacientes = List();

    for (Map paciente in listMap) {
      listPacientes.add(Paciente.fromMap(paciente));
    }
    return listPacientes;
  }
  //retorna a qtd de contatos da tabela
  Future<int> getNumber() async{
    Database dbPaciente = await db;
    return Sqflite.firstIntValue(await dbPaciente.rawQuery("SELECT COUNT(*) FROM $pacienteTable"));
  }

  //fecha o banco de dados
  Future close() async{
    Database dbPaciente = await db;
    dbPaciente.close();
  }

}


class Paciente {
  int id;
  String nome;
  String dataNascimento;
  String idade;
  String sexo;
  String raca;
  String foto;

  Paciente();

  Paciente.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    dataNascimento = map[dataNascimentoColumn];
    idade = map[idadeColumn];
    sexo = map[sexoColumn];
    raca = map[racaColumn];
    foto = map[fotoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      dataNascimentoColumn: dataNascimento,
      idadeColumn: idade,
      sexoColumn: sexo,
      racaColumn: raca,
      fotoColumn: foto
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Paciente(id: $id, nome: $nome, data nascimento: $dataNascimento, idade: $idade, sexo: $sexo, raça: $raca, foto: $foto)";
  }
}
