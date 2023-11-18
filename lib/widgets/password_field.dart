import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PassField extends StatefulWidget {
  String? label;
  String? hint;
  String? msError;
  bool error=false;
  var controler;
  bool isShow=false;
  GlobalKey<FormState> formkey =GlobalKey<FormState>();
  PassField({super.key,this.label, this.hint, this.msError});


  @override
  State <PassField> createState() =>  _PassFieldState();
}

class  _PassFieldState extends State <PassField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.key,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          obscureText: !widget.isShow? false : true,
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
              Icons.lock,
              color: Colors.white,),
            
            ),

           suffixIcon: Container(margin: const EdgeInsets.only(left: 14, right: 14),
            child: IconButton(
              icon: Icon(
                widget.isShow ?  Icons.visibility : Icons.visibility_off ,
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
           hintText: widget.hint,
           labelText: widget.label),
           autovalidateMode: AutovalidateMode.onUserInteraction,
           textInputAction: TextInputAction.next,
           onSaved: (value){
            widget.controler=value;
           },
           validator: (value){
            if(value!.isEmpty){
              return "Enter your password";
            }else if(widget.error){
              return widget.msError;

            }
           },
           onChanged: (value){
            widget.controler=value;
            widget.error= false;
           },
          ),
      ),
    );;
  }
}