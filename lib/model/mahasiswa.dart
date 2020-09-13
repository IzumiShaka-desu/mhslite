const String COLLUMN_ADDRESS='adress';
const String COLLUMN_YEARIN='year_in';
const String COLLUMN_GENDER='gender';
const String COLLUMN_NAME='name';
const String COLLUMN_NPM='npm';
const String COLLUMN_ID='id';
const String TABLE_MHS_NAME='mhs';
class Mahasiswa{
  int id,yearIn,npm;
  String address,gender,name;
  Mahasiswa({this.id,this.npm,this.address,this.gender,this.name,this.yearIn});

  factory Mahasiswa.fromMap(Map map)=>Mahasiswa(
    id:map[COLLUMN_ID],
    npm: map[COLLUMN_NPM],
    name: map[COLLUMN_NAME],
    gender: map[COLLUMN_GENDER],
    address: map[COLLUMN_ADDRESS],
    yearIn: map[COLLUMN_YEARIN]
  );

  Map<String,dynamic> toMap()=>{
    COLLUMN_ID:id,
    COLLUMN_NPM:npm,
    COLLUMN_NAME:name,
    COLLUMN_GENDER:gender,
    COLLUMN_ADDRESS:address,
    COLLUMN_YEARIN:yearIn
  };


} 