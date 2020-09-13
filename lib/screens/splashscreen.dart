
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhslite/screens/logres.dart';
import 'package:mhslite/service/sharepref_service.dart';

import '../constant.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate=false;
  setFull() {
    setState(() {
     isAnimate=true;
    });
  }

  @override
  void initState() {
    super.initState();
    
    delayMethod(2940, setFull);
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
              color: Colors.white,
          child: Center(
            child: Text('MHSAPP',style: TextStyle(fontSize:30,fontWeight:FontWeight.w800,color: primaryCardBlue),)
          ),
        )),
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          top: (isAnimate)?-height:-2,
          left: (isAnimate)?-width:-2,
                  child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            
            decoration: BoxDecoration(color:primaryCardBlue,shape: BoxShape.circle),
            height: (isAnimate)?height*3:0,
            width: (isAnimate)?width*3:0,
            onEnd: ()=>gotoHome(),
          ),
        )
      ],
    );
  }
  Future delayMethod(int delayMillis,Function method)async{
      return Timer(Duration(milliseconds: delayMillis),method);
}
  void gotoHome() async{
    bool isLogin =await SFService().isLogin();
    Widget target;
    (isLogin)?target=Home():target=LoginAndRegister();
   
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => target));
  }
}
