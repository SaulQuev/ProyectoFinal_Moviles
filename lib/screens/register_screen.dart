import 'package:flutter/material.dart';
import 'package:proyecto_moviles/firebase/email_auth.dart';
import 'package:proyecto_moviles/widgets/dialog_widget.dart';
import 'package:proyecto_moviles/widgets/down_list_gender.dart';
import 'package:proyecto_moviles/widgets/email_field.dart';
import 'package:proyecto_moviles/widgets/password_field.dart';
import 'package:proyecto_moviles/widgets/text_field_widget.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:social_login_buttons/social_login_buttons.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final emailAuth = EmailAuth();

  TextFieldWidget firstName = TextFieldWidget(
      label: "First name",
      hint: "First name",
      msError: "",
      inputType: 1,
      length: 50,
      icono: Icons.account_circle);
  TextFieldWidget lastName = TextFieldWidget(
      label: "Last name",
      hint: "Last name",
      msError: "",
      inputType: 1,
      length: 50,
      icono: Icons.account_circle);
  EmailField emailField = EmailField(
      label: "Email", hint: "Email", msError: "Email or password wrong");
  PassField passField = PassField();
  DownListGender downListGender = DownListGender();

/*  final conNameUser = TextEditingController();
  final conEmailUser = TextEditingController();
  final conPwdUser = TextEditingController();*/
  
  bool validateForm() {
    if (emailField.formkey.currentState!.validate()) {
      if (passField.formkey.currentState!.validate()) {
        return true;
      }
    }
    return false;
  }
  

  @override
  Widget build(BuildContext context) {
    DialogWidget dialogWidget = DialogWidget(context: context);

    ProgressDialog pd = ProgressDialog(context: context);

    Future<void> registerUser() async {
      if (validateForm()) {
        dialogWidget.showProgress();
        try {
          bool response = await emailAuth.createUser(
              emailUser: emailField.controler, pwdUser: passField.controlador);
          dialogWidget.closeprogress();
          if (response) {
            //esta linea dice si la respuesta no tiene un error
            dialogWidget.showSuccesDialog("Succesful register",
                "Se ha enviado un correo de confirmacion");
          } else
            dialogWidget.showErrorDialog(
              "Error en el registro",
              "Verifica los detalles y vuelve a intentar",
            );
        } catch (e) {
          print("Error: $e");
          dialogWidget.showErrorDialog(
            "Error inesperado",
            "Verifica tu conexión e intenta más tarde",
          );
        }
      }
    }

    final btnRegister= Padding(
    padding: const EdgeInsets.all(8.0),
    child: SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      backgroundColor: Colors.purple,
      borderRadius: 15,
      text: "Register",
      onPressed: () {
        if(validateForm()){
          registerUser();
        }
      },
    ),
  );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      body: Container(  //safeArea ignora la parte de arriba del telefon odonde aparece la hora
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.webp",
              height: 100, width: 250, fit: BoxFit.contain),
             Image.asset(
                    "assets/images/login_img.gif",
             height: 250, 
             width: 250,),
            const Text("Create your count", 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              ),),
            firstName,
            lastName,
            emailField,
            passField,
            downListGender,
            btnRegister
           
        ]),
        ), 
      )
    );
        /*ElevatedButton(
            onPressed: () {
              var email = conEmailUser.text;
              var pwd = conPwdUser.text;
              emailAuth.createUser(emailUser: email, pwdUser: pwd);
            },
            child: Text('Save User 💾'))*/

  }
}
