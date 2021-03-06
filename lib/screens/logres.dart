
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mhslite/database/db_service.dart';
import 'package:mhslite/model/login.dart';
import 'package:mhslite/service/sharepref_service.dart';

import '../constant.dart';
import '../utils.dart';
import 'home.dart';

class LoginAndRegister extends StatefulWidget {
  @override
  _LoginAndRegisterState createState() => _LoginAndRegisterState();
}

class _LoginAndRegisterState extends State<LoginAndRegister> {

  Map<String, TextEditingController> controller = {
    'emailLogin': TextEditingController(),
    'emailRegister': TextEditingController(),
    'fullname': TextEditingController(),
    'passwordLogin': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'password': TextEditingController(),
  };

  setControllerEmpty() {
    for (String i in controller.keys) {
      controller[i].text = '';
    }
  }
  GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();
  bool isSuccessfull = false;
  PageController _pageController = PageController();
  double currentPageValue = 0;
  bool isLoading = false;
  
  @override
  void initState() {
     super.initState();
    _pageController.addListener(() {
      setState(() {

        currentPageValue = _pageController.page;
      });
    });
   
  }

  @override
  Widget build(BuildContext context) {
    
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
          body: Container(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top:20),
            height: 130,
            child: Center(
                child: Text('MHSAPP',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: secodaryGreyActive))),
          ),
          Container(
            height: 30,
            child: DotsIndicator(dotsCount: 2,position:currentPageValue),
          ),
          Expanded(
              child: PageView.builder(
                
                controller: _pageController,
                  itemCount: 2,
                  physics: (isLoading)
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return Container(
                      
                        color: primaryCardBlue,
                      child: SingleChildScrollView(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15),
                            child: (isLoading)?Container(
                              child:Center(child: SizedBox(height:50,width:50,child:CircularProgressIndicator()),)
                            ):(index == 0)
                                ? Column(children: [
                                    SizedBox(height: 20),Text('Login',style:TextStyle(color: background,fontSize: 20,fontWeight: FontWeight.w700)),SizedBox(height:10),
                                    Container(
                                        width: size.width * 0.7,
                                        child: createTextField(
                                            controller['emailLogin'],
                                            "email",
                                            Icons.alternate_email)),
                                    SizedBox(height: 15),
                                    Container(
                                        width: size.width * 0.7,
                                        child: createTextField(
                                            controller['passwordLogin'],
                                            "password",
                                            Icons.lock_outline,
                                            isObscure: true)),
                                    SizedBox(height: 20),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                          onTap: () => exectLogin(
                                              controller['emailLogin'].text,
                                              controller['passwordLogin'].text),
                                          child: AnimatedContainer(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              height: 50,
                                              width: size.width * 0.6,
                                              child: Center(
                                                child: Text('Masuk',
                                                    style: TextStyle(
                                                        color: primaryCardBlue,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              curve: Curves.bounceOut,
                                              transform: Matrix4.identity()
                                                ..scale((currentPageValue ==
                                                        index.toInt())
                                                    ? 1.0
                                                    : 0.00000001),
                                              duration:
                                                  Duration(milliseconds: 250))),
                                    )
                                  ])
                                : Column(children: [
                                  SizedBox(height: 10),Text('Register',style:TextStyle(color: background,fontSize: 20,fontWeight: FontWeight.w700)),SizedBox(height:10),
                                    Container(
                                        width: size.width * 0.7,
                                        child: createTextField(
                                            controller['fullname'],
                                            "nama",
                                            Icons.account_circle)),
                                    Container(
                                        width: size.width * 0.7,
                                        child: createTextField(
                                            controller['emailRegister'],
                                            "email",
                                            Icons.alternate_email)),
                                    Container(
                                        width: size.width * 0.7,
                                        child: createTextField(
                                            controller['password'],
                                            "password",
                                            Icons.lock_outline,
                                            isObscure: true)),
                                    Container(
                                        width: size.width * 0.7,
                                        child: createTextField(
                                            controller['confirmPassword'],
                                            "konfirmasi password",
                                            Icons.lock_outline,
                                            isObscure: true)),
                                    SizedBox(height: 20),
                                    Center(
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                            onTap: () => (!isLoading)
                                                ? exectRegister(
                                                    controller['fullname'].text,
                                                    controller['password'].text,
                                                    controller['confirmPassword']
                                                        .text,
                                                    controller['emailRegister']
                                                        .text)
                                                : () {},
                                            child: AnimatedContainer(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(15)),
                                                height: 50,
                                                width: size.width * 0.6,
                                                child: Center(
                                                  child: Text('Daftar',
                                                      style: TextStyle(
                                                          color: primaryCardBlue,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                                curve: Curves.bounceOut,
                                                transform: Matrix4.identity()
                                                  ..scale((currentPageValue ==
                                                          index.toInt())
                                                      ? 1.0
                                                      : 0.00000001),
                                                duration:
                                                    Duration(milliseconds: 250))),
                                      ),
                                    )
                                  ])),
                      ),
                    );
                  }))
        ]),
      ),
    );
  }

  exectLogin(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    UserLogin result;
    String msg = '';
    var service = DbService();
    if (email == '' || password == '') {
      showSnackbar('form tidak boleh kosong');
    } else if (!emailValidator(email)) {
      showSnackbar('email tidak valid');
    } else {
      try {
        result = await service.login(email, password);
       if(result!=null) msg = 'login berhasil';
      } catch (e) {
        debugPrint(e.toString());
      }
      showSnackbar(msg);
    }
    setState(() {
      isLoading = false;
    });
    if (result!=null) {
      SFService().saveLoginDetails(result.email, result.fullname);
      goToDashboard();
    }
  }

  exectRegister(String fullname, String password, String confirmpassword,
      String email) async {
    setState(() {
      isLoading = true;
    });
    var service = DbService();
    if (fullname.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty ||
        email.isEmpty) {
      showSnackbar('form tidak boleh kosong');
    } else if (!emailValidator(email)) {
      showSnackbar('email tidak valid');
    } else if (password != confirmpassword) {
      showSnackbar('password dan konfirmasi password tidak sesuai');
    } else {
      bool result;
      String msg = '', timeout = '';
      try {
        result = await service.register(email, password,fullname);
        
      } catch (e) {
        debugPrint(e.toString());
      }
      if (result) {
        msg += 'register berhasil silahkan login';
        setControllerEmpty();
        _pageController.jumpToPage(0);
      }
      showSnackbar(msg + timeout);
    }
    setState(() {
      isLoading = false;
    });
  }

  goToDashboard() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }

  showSnackbar(String _msg) =>_sk.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.white,
      content: Material(
        type: MaterialType.transparency,
        child: Container(
          height: 50,
          child: Center(
              child: Row(
            children: [
              Expanded(
                child: Text(
                  _msg,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
            ],
          )),
        ),
      )));
}
