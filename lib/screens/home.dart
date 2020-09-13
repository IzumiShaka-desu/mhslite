import 'package:flutter/material.dart';
import 'package:mhslite/database/db_service.dart';
import 'package:mhslite/model/mahasiswa.dart';
import 'package:mhslite/service/sharepref_service.dart';
import 'package:mhslite/utils.dart';

import 'logres.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, TextEditingController> controller = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'npm': TextEditingController(),
    'year': TextEditingController(),
  };
  bool _gender = true;
  bool isLoading = true;
  bool isInputing = false;
  DbService service = DbService();
  List<Mahasiswa> mhs = [];
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  loadMhs() async {
    List<Mahasiswa> list = await service.readListMahasiswa();
    setState(() {
      mhs = list;
      isLoading = false;
    });
  }

  PersistentBottomSheetController _bottomSheetController;
  bool isBottomSheetOpened = false;

  void _showAddOrEditModal(BuildContext context, {Mahasiswa mahasiswa}) {
    if (mahasiswa != null) {
      setState(() {
        controller['name'].text = mahasiswa.name;
        controller['npm'].text = mahasiswa.npm.toString();
        controller['address'].text = mahasiswa.address;
        controller['year'].text = mahasiswa.yearIn.toString();
        _gender = getGenderBool(mahasiswa.gender);
      });

      _bottomSheetController =
          _sk.currentState.showBottomSheet((ctx) => Container(
                padding: EdgeInsets.all(5),
                child: Wrap(children: [
                  Text('edit data mahasiswa'),
                  SizedBox(height: 10),
                  createTextField(controller['name'], 'nama', Icons.person),
                  SizedBox(height: 10),
                  createTextField(controller['npm'], 'npm', Icons.person,
                      type: TextInputType.number),
                  SizedBox(height: 10),
                  createTextField(controller['address'], 'address', Icons.home),
                  SizedBox(height: 10),
                  createTextField(
                      controller['year'], 'tahun masuk', Icons.date_range,
                      type: TextInputType.number),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Radio<bool>(
                          value: true,
                          groupValue: _gender,
                          onChanged: (value) {
                            _bottomSheetController.setState(() {
                              _gender = value;
                            });
                          }),
                      Text('laki-laki'),
                      Radio<bool>(
                          value: false,
                          groupValue: _gender,
                          onChanged: (value) {
                            _bottomSheetController.setState(() {
                              _gender = value;
                            });
                          }),
                      Text('Perempuan'),
                    ],
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (!isInputing) {
                          if (checkNullForm(controller)) {
                            _sk.currentState.showSnackBar(
                                createSnacbar('form tidak boleh kosong'));
                          } else {
                            Mahasiswa mhs = Mahasiswa(
                                id: mahasiswa.id,
                                npm: int.parse(controller['npm'].text),
                                address: controller['address'].text,
                                gender: getGender(_gender),
                                name: controller['name'].text,
                                yearIn: int.parse(controller['year'].text));
                            setState(() {
                              isInputing = true;
                            });
                            bool result;
                            try {
                              result = await service.update(mhs);
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            if (result) {
                              _sk.currentState.showSnackBar(
                                  createSnacbar('data berhasil di edit'));
                              await loadMhs();

                              setState(() {
                                clearForm(controller);
                                isInputing = false;
                              });
                              _bottomSheetController.close();
                            } else {
                              _sk.currentState.showSnackBar(
                                  createSnacbar('data gagal di edit'));
                              setState(() {
                                isInputing = false;
                              });
                            }
                          }
                        }
                      },
                      child: Text('Simpan'))
                ]),
              ));
    } else {
      _bottomSheetController =
          _sk.currentState.showBottomSheet((ctx) => Container(
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Wrap(children: [
                    Text('tambah data mahasiswa'),
                    SizedBox(height: 10),
                    createTextField(controller['name'], 'nama', Icons.person),
                    SizedBox(height: 10),
                    createTextField(controller['npm'], 'npm', Icons.person,
                        type: TextInputType.number),
                    SizedBox(height: 10),
                    createTextField(
                        controller['address'], 'address', Icons.home),
                    SizedBox(height: 10),
                    createTextField(
                        controller['year'], 'tahun masuk', Icons.date_range,
                        type: TextInputType.number),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Radio<bool>(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  value: true,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    _bottomSheetController.setState(() {
                                      _gender = value;
                                    });
                                  }),
                              Text('laki-laki'),
                            ],
                          ),
                        ),
                        Radio<bool>(
                            value: false,
                            groupValue: _gender,
                            onChanged: (value) {
                              _bottomSheetController.setState(() {
                                _gender = value;
                              });
                            }),
                        Text('Perempuan'),
                      ],
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                        color: Colors.blue,
                        onPressed: () async {
                          if (!isInputing) {
                            if (checkNullForm(controller)) {
                              _sk.currentState.showSnackBar(
                                  createSnacbar('form tidak boleh kosong'));
                            } else {
                              Mahasiswa mhs = Mahasiswa(
                                  id: null,
                                  npm: int.parse(controller['npm'].text),
                                  address: controller['address'].text,
                                  gender: getGender(_gender),
                                  name: controller['name'].text,
                                  yearIn: int.parse(controller['year'].text));
                              setState(() {
                                isInputing = true;
                              });
                              bool result;
                              try {
                                result = await service.create(mhs);
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                              if (result) {
                                _sk.currentState.showSnackBar(
                                    createSnacbar('data berhasil di input'));
                                await loadMhs();

                                setState(() {
                                  clearForm(controller);
                                  isInputing = false;
                                });

                                _bottomSheetController.close();
                              } else {
                                _sk.currentState.showSnackBar(
                                    createSnacbar('data gagal di input'));
                                setState(() {
                                  isInputing = false;
                                });
                              }
                            }
                          }
                        },
                        child: Text('Simpan')),
                    SizedBox(height: 20)
                  ]),
                ),
              ));
    }
  }

  @override
  void initState() {
    loadMhs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
      appBar: AppBar(title: Text('Daftar mahasiswa'),actions: [IconButton(icon:Icon(Icons.exit_to_app),onPressed: ()async{
        await SFService().removeSaveLogin();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>LoginAndRegister()));
      },)],),
      body: Container(
          child: Center(
        child: (isLoading)
            ? SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              )
            : !(mhs.length > 0)
                ? Text(
                    'Daftar mahasiswa masih kosong',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  )
                : ListView.builder(
                    itemCount: mhs.length,
                    itemBuilder: (ctx, index) => Dismissible(
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you wish to delete this item?"),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("DELETE")),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("CANCEL"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async{
                             bool result= await service.delete(mhs[index].id);
                             if(result){
                               _sk.currentState.showSnackBar(createSnacbar('data berhasil dihapus'));

                             }else{
                             _sk.currentState.showSnackBar(createSnacbar('data gagal di hapus')); 
                             }
                          },
                          background: Container(
                              color: Colors.redAccent[700],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ],
                              )),
                          key: GlobalKey(),
                          child: Container(
                            height: 100,
                            child: Card(
                                child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      "NPM : ${mhs[index].npm}")),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      "Nama : ${mhs[index].name}")),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isBottomSheetOpened = true;
                                      });
                                      _showAddOrEditModal(context,
                                          mahasiswa: mhs[index]);
                                      _bottomSheetController.closed
                                          .then((value) {
                                        setState(() {
                                          clearForm(controller);
                                          isBottomSheetOpened = false;
                                        });
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      child: Column(children: [
                                        Icon(Icons.info_outline),
                                        Text('Info')
                                      ]),
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ),
                        )),
      )),
      floatingActionButton: FloatingActionButton(
          child: Transform.rotate(
              angle: isBottomSheetOpened ? 4 : 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                child: Icon(
                  Icons.add,
                  size: 35,
                ),
              )),
          onPressed: () {
            if (isBottomSheetOpened) {
              setState(() {
                isBottomSheetOpened = false;
              });
              _bottomSheetController.close();
            } else {
              setState(() {
                isBottomSheetOpened = true;
              });
              _showAddOrEditModal(context);
              _bottomSheetController.closed.then((value) {
                setState(() {
                  clearForm(controller);
                  isBottomSheetOpened = false;
                });
              });
            }
          }),
    );
  }
}
