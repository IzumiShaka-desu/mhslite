import 'package:flutter/material.dart';

import 'constant.dart';

getGender(bool isMale)=>isMale?'Laki Laki':'Perempuan';
getGenderBool(String gender)=>(gender=='Perempuan')?false:true;

emailValidator(String email) {
  if (email.contains('@')) {
    if (email.split('@')[1].contains('.')) {
      return true;
    }
  }
  return false;
}
void clearForm(Map<String,TextEditingController> controller){
  controller.forEach((key, value) {
    value.text='';
  });
}
createTextField(TextEditingController controller, String label, IconData icon,
        {bool isObscure,TextInputType type}) =>
    TextFormField(
        
        cursorColor: background,
        
        controller: controller,
        keyboardType: type??TextInputType.text,
        obscureText: isObscure ?? false,
        decoration: InputDecoration(
          
          focusColor: background,
            focusedBorder: UnderlineInputBorder(borderSide:BorderSide(color: background)),
            labelText: label,
            prefixIcon: Icon(icon),
            border: UnderlineInputBorder(),
            hintText: ' $label'));
bool checkNullForm(Map<String,TextEditingController> map){
    for(TextEditingController i in map.values){
     if(i.text.isEmpty){
       return i.text.isEmpty;
     }
        
    }

    return false;

}
SnackBar createSnacbar(String msg)=>SnackBar(
  behavior: SnackBarBehavior.floating,
  content: Container(
  padding:EdgeInsets.all(10),
  child:Wrap(children: [
    Text(msg)
  ],)
),);


