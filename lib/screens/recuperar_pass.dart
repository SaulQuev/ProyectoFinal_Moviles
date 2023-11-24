import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:proyecto_moviles/responsive.dart';
import 'package:proyecto_moviles/widgets/email_field.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
/*import 'package:tinder_itc/widgets/text_form_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';*/

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    EmailField txtEmail =
        EmailField(label: "Email", hint: "Email", msError: "Email wrong");
    final ValueNotifier<bool> _sent = ValueNotifier<bool>(false);

    final btnRecovery = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SocialLoginButton(
        buttonType: SocialLoginButtonType.generalLogin,
        backgroundColor: Colors.green,
        onPressed: () async {
          if (txtEmail.formkey.currentState!.validate()) {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: txtEmail.controler)
                .then((value) => _sent.value = true);
          }
        },
        borderRadius: 15,
        mode: SocialLoginButtonMode.single,
        text: 'Recuperar contraseña',
      ),
    );

    final form = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [txtEmail, SizedBox(height: 50), btnRecovery],
    );

    Widget recoveryData(Column form) {
      return SizedBox(
        child: ValueListenableBuilder(
            valueListenable: _sent,
            builder: (context, value, _) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (_sent.value)
                      ? [
                          LottieBuilder.asset(
                            'assets/animation/email-sent.json',
                            repeat: false,
                          ),
                          const Text(
                            'Hemos enviado un link a tu correo electrónico para restablecer tu contraseña!',
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          )
                        ]
                      : [
                          Column(
                            children: [
                              Container(
                                width: 150,
                                height: 100,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/logo.webp',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(height: 80),
                              Container(
                                child: const Align(
                                  child: Text(
                                    "Ingrese su email para cambiar su contraseña",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 100),
                          form
                        ]);
            }),
      );
    }

    return Scaffold(
      body: Responsive(
        mobile: MobileViewWidget(
          recoveryData: recoveryData(form),
        ),
        desktop: MobileViewWidget(recoveryData: recoveryData(form)),
      ),
    );
  }
}

class MobileViewWidget extends StatelessWidget {
  MobileViewWidget({super.key, required this.recoveryData});

  Widget recoveryData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: SingleChildScrollView(
          child: recoveryData,
        ),
      ),
    );
  }
}