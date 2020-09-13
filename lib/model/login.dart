import 'package:mhslite/model/mahasiswa.dart';

const String COLLUMN_EMAIL = 'email';
const String COLLUMN_FULLNAME = 'fullname';
const String COLLUMN_PASSWORD = 'password';
const String TABLE_LOGIN_NAME = 'userLogin';

class UserLogin {
  int id;
  String email;
  String fullname;
  String password;
  UserLogin({this.id, this.email, this.fullname, this.password});
  Map<String, dynamic> toMap() => {
        COLLUMN_ID: id,
        COLLUMN_EMAIL: email,
        COLLUMN_FULLNAME: fullname,
        COLLUMN_PASSWORD: password,
      };
  factory UserLogin.fromMap(Map map) => UserLogin(
      email: map[COLLUMN_EMAIL],
      id: map[COLLUMN_ID],
      fullname: map[COLLUMN_FULLNAME]);
}
