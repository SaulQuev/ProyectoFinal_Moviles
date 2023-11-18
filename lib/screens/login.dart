import 'package:flutter/material.dart';
import 'package:proyecto_moviles/firebase/EmailAuth.dart';
import 'package:proyecto_moviles/widgets/dialog_widget.dart';
import 'package:proyecto_moviles/widgets/email_field.dart';
import 'package:proyecto_moviles/widgets/password_field.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
//s_L S
  final emailAuth = EmailAuth();
  bool loginFailed = false;
  //ApiUser apiUser =ApiUser();

//se crean los objetos
  EmailField emailField = EmailField(
    label: "Email",
    hint: "Email",
    msError: "Email or password wrong",
  );
  PassField passField = PassField(
      label: "Password", hint: "Password", msError: "Email or password error");

  bool isShow = false;
  var controllerEmail;
  final btnGoogle = SocialLoginButton(
    buttonType: SocialLoginButtonType.google,
    text: "",
    width: 77,
    borderRadius: 15,
    mode: SocialLoginButtonMode.single,
    onPressed: () {},
  );
  final btnApple = SocialLoginButton(
    buttonType: SocialLoginButtonType.github,
    text: "",
    width: 77,
    borderRadius: 15,
    mode: SocialLoginButtonMode.single,
    onPressed: () {},
  );

  final btnFB = SocialLoginButton(
    buttonType: SocialLoginButtonType.facebook,
    text: "",
    width: 77,
    borderRadius: 15,
    mode: SocialLoginButtonMode.single,
    onPressed: () {},
  );

  bool validateForm() {
    if (loginFailed) {
      if (emailField.msError == "Email or password wrong" &&
          !emailField.formkey.currentState!.validate()) {
        return true;
      } else if (passField.msError == "Email or password wrong" &&
          !passField.formkey.currentState!.validate()) {
        return true;
      }
    }
    if (emailField.formkey.currentState!.validate()) {
      if (passField.formkey.currentState!.validate()) {
        return true;
      }
    }
    return false;
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    DialogWidget dialogWidget = DialogWidget(context: context);

/*se hace la peticion
    Future<void> login() async{
      final userModel = UserModel(
        email: emailField.controler,
        password: passField.controler);
        dialogWidget.showProgress();
        var response =await apiUser.login(userModel);
        dialogWidget.closeprogress();
      if(!response.containsKey("Error")){
        //si todo bien al loguearse manda a la ventana de home con la sigiente linea
        Navigator.pushNamed(context, "/home");
      }else{
        loginFailed = true;
        if(response["Error"]=="Login failed"){
          emailField.error=true;
          emailField.formkey.currentState!.validate();
          passField.error=true;
          passField.formkey.currentState!.validate();
        }else if(response["Error"]== "Tiempo de espera agotado"){
              dialogWidget.showErrorDialog("tiempo de espera agotado", "Verifica tu conexion a internet e intente mas tarde");
        }
      }

    }*/

    final btnLogin = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SocialLoginButton(
        buttonType: SocialLoginButtonType.generalLogin,
        backgroundColor: Colors.purple,
        borderRadius: 15,
        onPressed: () async {
          if (validateForm()) {
            //login(); aqui debe ir el metodo que hace el login
            bool res = await emailAuth.validateUser(
              emailUser: emailField.controler,
              pwdUser: passField.controler,
            );
            if (res) {
              Navigator.pushNamed(context, '/dash');
            } else {
              // caso en el que la autenticación falla
              // mostrar un mensaje de error etc.
            }
          }
        },
      ),
    );

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
        body: Container(
          //safeArea ignora la parte de arriba del telefon odonde aparece la hora
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("image/logo.webp",
                      height: 100, width: 250, fit: BoxFit.contain),
                  Image.asset(
                    "image/login_img.gif",
                    height: 250,
                    width: 250,
                  ),
                  const Text(
                    "Inicio de sesión",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  emailField,
                  passField,
                  btnLogin,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [btnGoogle,btnApple ,btnFB],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Do you have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: TextButton(
                            //dentro del atributo onpresed se pone el codigo para navegar entre pantallas
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  "/register"); //se guardan como pila ultimo que ingresa es el primero
                            },
                            child: const Text(
                              "Create your account",
                              style: TextStyle(color: Colors.purple),
                            )),
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forget your password",
                        style: TextStyle(color: Colors.purpleAccent),
                      )),
                ]),
          ), //en esta columna se ponen varios windgets, text y container solo aceptn 1 widget
        ) //es un widget
        ); //es un contenedor
  }
}
