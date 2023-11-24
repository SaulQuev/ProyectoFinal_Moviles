import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {

String? label;
String? hint;
String? msError;
int? inputType;//para saber el tipo de salida
int? length;
IconData? icono;
var controler;
bool error=false;

GlobalKey<FormState> formkey =GlobalKey<FormState>();

  TextFieldWidget({super.key,this.label, this.hint, this.msError, this.inputType, this.length, this.icono});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(widget.length)],
        style: const TextStyle(color: Colors.white),
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
          child: Icon(
            widget.icono,
            color: Colors.white,),
          
          ),
    
         hintStyle: const TextStyle(color: Colors.white),
         labelStyle: const TextStyle(color: Colors.white),
         hintText: widget.hint,
         labelText: widget.label),
         keyboardType: widget.inputType==0?TextInputType.number:TextInputType.text,
          //para autocompletar el correo
         textInputAction: TextInputAction.next, //para avanzar a la siguiente parte al teclear la flecha del teclado
         onSaved: (value){
            widget.controler=value; 
         },
         validator: (value){
          if(value!.isEmpty){
            return "Enter in this field";
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