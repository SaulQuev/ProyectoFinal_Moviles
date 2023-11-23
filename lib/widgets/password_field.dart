import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PassField extends StatefulWidget {
  /*String? label;
  String? hint;
  String? msError;
  bool error=false;
  var controler;
  bool isShow=false;*/
  var visible = true;
  var error = false;
  bool isShow=false;
  var controlador;
  GlobalKey<FormState> formkey =GlobalKey<FormState>();

  /*PassField({super.key,this.label, this.hint, this.msError});*/


  @override
  State <PassField> createState() =>  _PassFieldState();
}

class  _PassFieldState extends State <PassField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Form(
      key: widget.formkey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          obscureText: !widget.isShow? false : true,
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Password",
            hintText: ("Ingresa tu contraseña"),
            enabledBorder: 
                OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
            focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(20)) ,
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)) ,
                focusedErrorBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)) ,
            prefixIcon: Container(margin: const EdgeInsets.only(left: 14, right: 14),
            child: const Icon(
              Icons.lock,
              color: Colors.white,),
            
            ),

           suffixIcon: Container(margin: const EdgeInsets.only(left: 14, right: 14),
            child: IconButton(
              icon: Icon(
                widget.isShow ?  Icons.visibility_off :  Icons.visibility,
              color: widget.isShow ?  Colors.purple : Colors.white,
              ),
              onPressed: () { 
                setState(() {
                  widget.isShow = !widget.isShow;
                });
               },
               ),
              ),

           hintStyle: const TextStyle(color: Colors.white),
           labelStyle: const TextStyle(color: Colors.white),
           //hintText: widget.hint,
           /*labelText: widget.label*/),
           autovalidateMode: AutovalidateMode.onUserInteraction,
           textInputAction: TextInputAction.next,
           onSaved: (value){
            widget.controlador=value;
           },
  
           validator: (value){
            if(value!.isEmpty){
              widget.error=true;
              return "Enter your password";
            }else if(widget.error){
              widget.error=true;
              return "Email or password wrong";

            }
           },
           onChanged: (value){
            widget.controlador=value;
            widget.error= false;
           },
          ),
      ),
    )
    );
  }
}