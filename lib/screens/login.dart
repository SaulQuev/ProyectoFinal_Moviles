import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_moviles/firebase/EmailAuth.dart';
import 'package:proyecto_moviles/firebase/googleAuth.dart';
import 'package:proyecto_moviles/user_preferences_dev.dart';
import 'package:proyecto_moviles/widgets/alert_widget.dart';
import 'package:proyecto_moviles/widgets/dialog_widget.dart';
import 'package:proyecto_moviles/widgets/email_field.dart';
import 'package:proyecto_moviles/widgets/password_field.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:proyecto_moviles/provider/user_provider.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {

  final emailAuth = EmailAuth();
  AccessToken? _accessToken;
  bool loginFailed = false;
   bool _checking = false;
  Map<String, dynamic>? _userData;
  //ApiUser apiUser =ApiUser();
late EmailField emailField;  // Añade 'late' aquí
late PassField passField; 
GlobalKey<FormState> formkey = GlobalKey<FormState>();
/*se crean los objetos
  EmailField emailField = EmailField(
    label: "Email",
    hint: "Email",
    msError: "Email or password wrong",
  );
  PassField passField = PassField(
      label: "Password", hint: "Password", msError: "Email or password error");*/

  bool isShow = false;
  var controllerEmail;
  void checkSavedSession() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if(accessToken != null){
      print(accessToken.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }else{
      _loginFB();
    }
  }


  
  /*final btnGoogle = SocialLoginButton(
    buttonType: SocialLoginButtonType.google,
    text: "",
    width: 60,
    borderRadius: 15,
    mode: SocialLoginButtonMode.single,
    onPressed: () {},
  );*/
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
    onPressed:() { 
      //_loginFB();
      }
  );
 @override
  void initState() {
    super.initState();
    emailField = EmailField(
      label: "Email",
      hint: "Email",
      msError: "Email or password wrong",
    );
    passField =PassField();
  }

  bool validateForm() {
    if (loginFailed) {
      if (emailField.msError == "Email or password wrong" &&
          !emailField.formkey.currentState!.validate()) {
        return true;
      } else if (passField.error == "Email or password wrong" && !passField.formkey.currentState!.validate()) {
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

  
  @override
  Widget build(BuildContext context) {
  GoogleAuth _googleAuth = GoogleAuth();
  DialogWidget dialogWidget = DialogWidget(context: context);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  

//se hace la peticion
    Future<void> login() async{
      dialogWidget.showProgress();

  // Llamada al método validateUser de emailAuth
  bool res = await emailAuth.validateUser(
    emailUser: emailField.controler,
    pwdUser: passField.controlador,
  );
      
        dialogWidget.closeprogress();
      if(res){
        //si todo bien al loguearse manda a la ventana de home con la sigiente linea
        Navigator.pushNamed(context, "/dash");
      }else{
        loginFailed = true;
        ////if(response["Error"]=="Login failed"){
          emailField.error=true;
          emailField.formkey.currentState!.validate();
          passField.error=true;
          passField.formkey.currentState!.validate();
       // }else if(response["Error"]== "Tiempo de espera agotado"){
              dialogWidget.showErrorDialog("tiempo de espera agotado", "Verifica tu conexion a internet e intente mas tarde");
        }
      }
       
       
       final btnRedirectReg = ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: const Text('Completar registro'));

    final btnGoogle = SocialLoginButton(
      width: 122,
      text: "",
      buttonType: SocialLoginButtonType.google,
      mode: SocialLoginButtonMode.multi,
      onPressed: () {
        _googleAuth.signInWithGoogle().then((value) {
          if (value == 'logged-successful') {
            //redireccionar al dashboard
            /*AlertWidget.showMessage(
                context, 'Acceso exitoso', 'Has ingresado a tu cuenta');
            userProvider.setUserData(UserPreferencesDev.getUserObject());*/
            Navigator.pushNamed(context, '/dash');
          }/*else if (value == 'logged-without-info') {
            //redireccionar al register_screen - RegisterScreen debe
            AlertWidget.showMessageWithActions(
                context,
                'Creación exitoso',
                'Tu cuenta de google ha sido creada correctamente, procede a completar el registro porfavor',
                [btnRedirectReg]);
          }*/
        });
      },
      borderRadius: 15,
    );
    

    final btnLogin = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SocialLoginButton(
        buttonType: SocialLoginButtonType.generalLogin,
        backgroundColor: Colors.green,
        borderRadius: 15,
        onPressed: () async {
          if (validateForm()) {
            login();
            /*/login(); aqui debe ir el metodo que hace el login
            bool res = await emailAuth.validateUser(
              emailUser: emailField.controler,
              pwdUser: passField.controler,
            );
            if (res) {
              Navigator.pushNamed(context, '/dash');
            } else {
              // caso en el que la autenticación falla
              // mostrar un mensaje de error etc.
            }*/
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
                  Image.asset("assets/images/logo.webp",
                      height: 100, width: 250, fit: BoxFit.contain),
                  Image.asset(
                    "assets/images/login_img.gif",
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
                              style: TextStyle(color: Colors.lightGreen),
                            )),
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                         Navigator.pushNamed(context, '/new_password');
                      },
                      child: const Text(
                        "Forget your password",
                        style: TextStyle(color: Colors.green),
                      )),
                ]),
          ), //en esta columna se ponen varios windgets, text y container solo aceptn 1 widget
        ) //es un widget
        ); //es un contenedor
  }
 _loginFB() async {
  final LoginResult result = await FacebookAuth.instance.login();

  if (result.status == LoginStatus.success) {
    _accessToken = result.accessToken;
    final userData = await FacebookAuth.instance.getUserData();
    _userData = userData;
  } else {
    print(result.status);
    print(result.message);
  }

  setState(() {
    _checking = false;
    Navigator.pushNamed(context, '/dash');
  });
}

_logoutFB() async{
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {
    });
  }
}
