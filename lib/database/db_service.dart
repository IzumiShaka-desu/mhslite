import 'package:flutter/widgets.dart';
import 'package:mhslite/database/database.dart';
import 'package:mhslite/model/login.dart';
import 'package:mhslite/model/mahasiswa.dart';

class DbService {
  DbHelper _dbHelper = DbHelper();
  Future<bool> create(Mahasiswa mhs) async {
    
      await _dbHelper.openDb();
      int result = await _dbHelper.insert(mhs);
      print(result);
      await _dbHelper.close();
      if (result > 0) return true;
      else return false;
  }

  Future<List<Mahasiswa>> readListMahasiswa() async {
    List<Mahasiswa> mhs = [];
    try {
      await _dbHelper.openDb();
      List<Mahasiswa> list = await _dbHelper.getListMahasiswa();

      await _dbHelper.close();
      if (list.length > 0) {
        mhs = list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return mhs;
  }

  Future<Mahasiswa> readDetailMahasiswa(int id) async {
    try {
      await _dbHelper.openDb();
      Mahasiswa mhs = await _dbHelper.getDetailMahasiswa(id);
      await _dbHelper.close();
      if (mhs != null) {
        return mhs;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> update(Mahasiswa mhs) async {
    try {
      await _dbHelper.openDb();
      int result = await _dbHelper.update(mhs);
      if (result > 0) return true;
      await _dbHelper.close();
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> delete(int id) async {
    try {
      await _dbHelper.openDb();
      bool result = await _dbHelper.deleteMahasiswa(id);
      await _dbHelper.close();
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<UserLogin> login(String email, String password) async {
    try {
      await _dbHelper.openDb();
      UserLogin result = await _dbHelper.login(email, password);
      await _dbHelper.close();
      if(result!=null){
        return result;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> register(String email, String password,String fullname) async {
   
   try{
    await _dbHelper.openDb();
    int result =await _dbHelper.register(email, password, fullname);
    await _dbHelper.close();
    if(result>0){
      return true;
    }
   }catch(e){
     debugPrint(e.toString());
   }
  return false;
  }
}
