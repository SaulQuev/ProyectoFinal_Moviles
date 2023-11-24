import 'package:flutter/material.dart';

class DownListGender extends StatefulWidget {
  DownListGender({super.key});
  String? control= "male"; //este control es para recuperar lo que se selecciona de la lista

  @override
  State<DownListGender> createState() => _DownListGenderState();

}

//los arreglos funcionan como listas en fluutr es decir no hay arreglos solo array list

class _DownListGenderState extends State<DownListGender> {
  //se creaa la lista
  List<String> genders =["male","female","Other"];
  String dropDownValue="male";//valor por defecto
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: dropDownValue,
        dropdownColor: Colors.black87,
        icon: const Icon(Icons.expand_more),
        decoration: InputDecoration(
          enabledBorder: 
              OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
          focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(20)) ,
                errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(20)) ,
                focusedErrorBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(20)) ,
          prefixIcon: Container(margin: const EdgeInsets.only(left: 14, right: 14),
          child: const Icon(
            Icons.man,
            color: Colors.white,),
          
          ),
    
         hintStyle: const TextStyle(color: Colors.white),
         labelStyle: const TextStyle(color: Colors.white),
         hintText: "Gender",
         labelText: "Gender"),
        items: genders.map<DropdownMenuItem<String>>((String value){
          return DropdownMenuItem<String>(value: value,
          child: Text(value, style: const TextStyle(color: Colors.white),),);
        }).toList(), 
        onChanged: (String? newValue){
          dropDownValue= newValue!;
          widget.control= newValue;
        }),
    );
  }
}