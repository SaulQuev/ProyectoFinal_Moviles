import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailField extends StatefulWidget {
String? label;
String? hint;
String? msError;
var controler;
bool error=false;
GlobalKey<FormState> formkey =GlobalKey<FormState>();

  EmailField({super.key,this.label, this.hint, this.msError});

  @override
  State <EmailField> createState() =>  EmailFieldState();
}



class  EmailFieldState extends State <EmailField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
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
            Icons.email,
            color: Colors.white,),
          
          ),
    
         hintStyle: const TextStyle(color: Colors.white),
         labelStyle: const TextStyle(color: Colors.white),
         hintText: widget.hint,
         labelText: widget.label),
         keyboardType: TextInputType.emailAddress,
         autofillHints: {AutofillHints.email}, //para autocompletar el correo
         textInputAction: TextInputAction.next, //para avanzar a la siguiente parte al teclear la flecha del teclado
         onSaved: (value){
            widget.controler=value; 
         },
         validator: (value){
          if(value!.isEmpty){
            return "Enter an email";
          }else
           if(!EmailValidator.validate(value)){
            return "Enter email valited";
          }else if(widget.error){
            return widget.msError;
          }
         }, autovalidateMode: AutovalidateMode.onUserInteraction,
         onChanged: (value){
            setState(() {
              widget.controler=value;
              widget.error=false;//para quitar el error cuando aparezca, para que no se quede activado
            });
         },
        ),
    ));
  }
}