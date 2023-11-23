import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:proyecto_moviles/utils/user_simple_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CambioFoto extends StatefulWidget {
  const CambioFoto({super.key});

  @override
  State<CambioFoto> createState() => _CambioFotoState();
}

class _CambioFotoState extends State<CambioFoto> {
  userPreferences preferences = userPreferences();
  late String fotoPerfil = "";
  var img;
  late String img64;
  bool hasError = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

   Future<String> uploadImageToFirebase(XFile? imageFile) async {
    if (imageFile == null) {
   print('La imagen es nula');
    return ''; 
  }
    try {
      var currentUser = _auth.currentUser;
      if (currentUser == null) {
         print('Usuario no autenticado.');
      throw Exception('Usuario no autenticado');
      }
        var userId = currentUser.uid;
        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = _storage.ref().child('profile_images/$userId/$imageName.png');
        await storageRef.putFile(File(imageFile.path));
        var imageUrl = await storageRef.getDownloadURL();
        return imageUrl;
     }catch (e) {
      print('Error al subir la imagen: $e');
      throw e;
    }
  }

  Future<void> saveImageReferenceInFirestore(String imageUrl) async {
    try {
    var currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Usuario no autenticado.');
      throw Exception('Usuario no autenticado');
    }

    var userId = currentUser.uid;
    var userCollection = _firestore.collection('users');

    // Verificar si la colección ya existe
    var collectionExists = await userCollection.get();
    if (collectionExists.docs.isEmpty) {
      // Si no existe, créala
      await userCollection.add({});
    }

    // Agregar el documento con la URL de la imagen
    await userCollection.doc(userId).update({
      'profileImageUrl': imageUrl,
    });
  } catch (e) {
    print('Error al guardar la referencia en Firestore: $e');
    throw e;
    }

  }
    /*try {
      var currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Usuario no autenticado.');
      throw Exception('Usuario no autenticado');
    }

        var userId = currentUser.uid;
        
        await _firestore.collection('users').doc(userId).update({
          'profileImageUrl': imageUrl,
        });
    } catch (e) {
      print('Error al guardar la referencia en Firestore: $e');
      throw e;
    }
    */
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back,
                            color: Theme.of(context).primaryColorLight,
                            size: 20),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(0),
                          primary: Colors.transparent,
                        ),
                      ),
                      Text(
                        "Editar perfil",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontFamily: "PopPins",
                            fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            )),
        body: hasError
            ? SafeArea(
                child: Center(
                child: Container(
                  height: 500,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset("assets/hasNotInternet.png",
                            height: 300),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Ha ocurrido un error inesperado. \n Compruebe su conexión, intente más tarde",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColorLight),
                            textAlign: TextAlign.center,
                          ))
                        ],
                      ),
                      Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(5, 3, 10, 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColorDark),
                          child:
                              Icon(Icons.info, size: 30, color: Colors.white)),
                      TextButton(
                        child: Text(
                          'Intentar de nuevo',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: "Poppins"),
                        ),
                        onPressed: () async {},
                      ),
                    ],
                  ),
                ),
              )

                //Image.asset(count==2?"assets/inicio2.gif":"assets/inicio.gif", height: 300,),
                )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  children: <Widget>[
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        //padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromRGBO(23, 32, 42, 1),
                              radius: 60,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 55,
                                backgroundImage: img == null
                                    ? NetworkImage(
                                        "https://scontent.fcyw4-1.fna.fbcdn.net/v/t1.6435-9/147282030_3758020080926332_2824307540345505213_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=be3454&_nc_ohc=2KIApUETjWcAX_iBwLT&_nc_ht=scontent.fcyw4-1.fna&oh=00_AfB8uR83t7Rc-W1iT-dfqZIIHjPdPw3YTvTc3Tk9wzx9PQ&oe=657EB2A7")
                                    : FileImage(img) as ImageProvider,
                              ),
                            ),
                            Transform.translate(
                                offset: Offset(50, -40),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromRGBO(23, 32, 42, 1),
                                  radius: 30,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      AwesomeDialog(
                                              dialogBackgroundColor:
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                              context: context,
                                              dialogType: DialogType.info,
                                              headerAnimationLoop: true,
                                              animType: AnimType.bottomSlide,
                                              titleTextStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                              title:
                                                  "¿Permitir que la aplicación acceda a tus archivos?",
                                              buttonsTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              closeIcon: Icon(
                                                Icons.close,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                              showCloseIcon: true,
                                              btnOkOnPress: () async {
                                                XFile? PickedImage =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            imageQuality: 50);
                                                setState(() {
                                                  img = File(PickedImage!.path);
                                                });
                                                var imageUrl=
                                                await uploadImageToFirebase(PickedImage);
                                                
                                                await saveImageReferenceInFirestore(imageUrl);
                                                var bytes =
                                                    await img.readAsBytesSync();
                                                img64 = base64.encode(bytes);
                                              },
                                              btnCancelOnPress: () {})
                                          .show();
                                      //await this.usuarioHttp.subir_foto(img64);
                                    },
                                  ),
                                )),
                          ],
                        ),
                      );
                    }),
                    /*Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 150,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                //margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(
                                            70, 165, 37, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: const Text(
                                      'Guardar',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      if (valiUser()) {
                                        pr.show();
                                        var responde = await editUsuario();
                                        pr.hide();
                                        if (responde.containsKey('error')) {
                                          if (responde['error'] ==
                                              'La contraseña no corresponde') {
                                            AwesomeDialog(
                                                    dialogBackgroundColor: Theme
                                                            .of(context)
                                                        .scaffoldBackgroundColor,
                                                    context: context,
                                                    dialogType:
                                                        DialogType.error,
                                                    headerAnimationLoop: true,
                                                    animType:
                                                        AnimType.bottomSlide,
                                                    titleTextStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight),
                                                    descTextStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight),
                                                    title:
                                                        "La contraseña no corresponde",
                                                    desc:
                                                        "No se puede continuar hasta que ingreses correctamente la contraseña",
                                                    buttonsTextStyle:
                                                        const TextStyle(
                                                            color:
                                                                Colors.black),
                                                    closeIcon: Icon(
                                                      Icons.close,
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                    ),
                                                    showCloseIcon: true,
                                                    btnOkOnPress: () {})
                                                .show();
                                          } else
                                            print("error inesperado");
                                        } else {
                                          await preferences.actualizar(
                                              this.nombre.controlador,
                                              this.apellidos.controlador,
                                              fotoPerfil);
                                          openDialogSuccess alerta =
                                              openDialogSuccess("Exito",
                                                  "Se han actualizado tus datos correctamente");
                                          await AwesomeDialog(
                                              dialogBackgroundColor:
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                              context: context,
                                              dialogType: DialogType.success,
                                              headerAnimationLoop: true,
                                              animType: AnimType.bottomSlide,
                                              titleTextStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                              title:
                                                  "Se han actualizado tus datos correctamente",
                                              buttonsTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              closeIcon: Icon(Icons.close,
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                              showCloseIcon: true,
                                              btnOkOnPress: () {
                                                Navigator.of(context).pop();
                                              }).show();
                                          Navigator.of(context).pop();
                                        }
                                      } else {
                                        print("error en onPressed1");
                                      }
                                    }),
                              ),
                            ])
                          )*/
                  ],
                ),
              ));
  }
/*
  Future<Map<String, dynamic>> editUsuario() async {
    // Inicializa la variable fotoPerfil como una cadena vacía
    fotoPerfil = "";

    // Comprueba si se proporcionó una imagen (img no es nulo)
    if (img != null) {
      // Intenta subir la foto y obtiene la respuesta
      var responde = await this.usuarioHttp.subir_foto(img64);

      // Comprueba si la respuesta contiene un error
      if (responde.containsKey('error')) {
        // Si hay un error, imprime un mensaje y utiliza la fotoPerfil actual del usuario
        print("error");
        fotoPerfil = listDataUsuario["data"][0]["fotoPerfil"];
      } else {
        // Si no hay error, utiliza la URL de la imagen subida
        fotoPerfil = responde["link"];
      }
    } else {
      // Si no se proporcionó una imagen, utiliza la fotoPerfil actual del usuario
      print("qui");
      print(listDataUsuario["data"][0]["fotoPerfil"]);
      fotoPerfil = listDataUsuario["data"][0]["fotoPerfil"];
    }

    // Llama al método edit_usuario de la clase usuarioHttp con los parámetros obtenidos
    Map<String, dynamic> r = await this.usuarioHttp.edit_usuario(fotoPerfil);

    // Devuelve la respuesta
    return r;
  }*/
}
