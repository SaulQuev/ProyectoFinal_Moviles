import 'package:flutter/material.dart';
import 'package:proyecto_moviles/firebase/email_auth.dart';
import 'package:proyecto_moviles/styles/global_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailAuth = EmailAuth();
  @override
  Widget build(BuildContext context) {
    TextEditingController txtConUser = TextEditingController();
    TextEditingController txtConPass = TextEditingController();

    final txtUser = TextField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      controller: txtConUser,
    );

    final txtPass = TextField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      controller: txtConPass,
      obscureText: true,
    );

    final imgLogo = Container(
      width: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/2919/2919600.png')),
      ),
    );

    final btnEntrar = FloatingActionButton.extended(
        icon: const Icon(Icons.login),
        label: const Text('ENTRAR'),
        onPressed: () async{
          bool res = await emailAuth.validateUser(emailUser: txtConUser.text, pwdUser: txtConPass.text);
          if(res ){
            Navigator.pushNamed(context, '/dash');
          }
        }
        );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              opacity: .9,
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://i.pinimg.com/736x/7f/24/ec/7f24ecd06e70a65b29c68889dac0a220.jpg')),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              
              Container(
                height: 250,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
                //color: Colors.blueGrey,
                child: Column(children: [
                  txtUser,
                  const SizedBox(height: 10),
                  txtPass,
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                      valueListenable: GlobalValues.flagCheckBox,
                      builder: (context, value, _) {
                        return Row(
                          children: [
                            const Text("Guardar sesión",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )),
                            Checkbox(
                                value: GlobalValues.flagCheckBox.value,
                                onChanged: (state) async {
                                  GlobalValues.flagCheckBox.value = state!;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  if (state) {
                                    prefs.setBool('isLogged', true);
                                  } else {
                                    prefs.setBool('isLogged', false);
                                  }
                                }),
                                TextButton(
                                  onPressed: ()=>Navigator.pushNamed(context,'/register'),
                                  child: Text('Registrarme', 
                                    style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 53, 53, 250),decoration: TextDecoration.underline )))   
                          ],
                        );
                        
                      })
                ]),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 200), child: imgLogo)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: btnEntrar,
    );
  }
}
